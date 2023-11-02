#
# Copyright 2020-2023 Hewlett Packard Enterprise Development LP
# Copyright 2004-2019 Cray Inc.
# Other additional copyright holders may be indicated within.
#
# The entirety of this work is licensed under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
#
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

import chapel
import chapel.core

IgnoreAttr = ("chplcheck.ignore", ["rule", "comment"])
def ignores_rule(node, rulename):
    """
    Given an AST node, check if it has an attribute telling it to silence
    warnings for a given rule.
    """

    ag = node.attribute_group()

    if ag is None: return False
    for attr in ag:
        attr_call = chapel.parse_attribute(attr, IgnoreAttr)
        if attr_call is None: continue

        ignored_rule = attr_call["rule"]
        if ignored_rule is not None and ignored_rule.value() == rulename:
            return True

    return False

class LintDriver:
    """
    Driver class containing the state and methods for linting. Among other
    things, contains the rules for emitting warnings, as well as the
    list of rules that should be silenced.

    Provides the @driver.basic_rule and @driver.advanced_rule decorators
    for registering new rules.
    """

    def __init__(self):
        self.SilencedRules = []
        self.BasicRules = []
        self.AdvancedRules = []

    def disable_rules(self, *rules):
        """
        Tell the driver to silence / skip warning for the given rules.
        """

        self.SilencedRules.extend(rules)

    def enable_rules(self, *rules):
        """
        Tell the driver to warn for the given rules even if they were
        previously disabled.
        """

        self.SilencedRules = list(set(self.SilencedRules) - set(rules))

    def _should_check_rule(self,rulename, node = None):
        if rulename in self.SilencedRules:
            return False

        if node is not None and ignores_rule(node, rulename):
            return False

        return True

    def _check_basic_rule(self, context, root, rule):
        (name, nodetype, func) = rule

        # If we should ignore the rule no matter the node, no reason to run
        # a traversal and match the pattern.
        if not self._should_check_rule(name):
            return

        for (node, _) in chapel.each_matching(root, nodetype):
            if not self._should_check_rule(name, node):
                continue

            if not func(context, node):
                yield (node, name)

    def _check_advanced_rule(self, context, root, rule):
        (name, func) = rule

        # If we should ignore the rule no matter the node, no reason to run
        # a traversal and match the pattern.
        if not self._should_check_rule(name):
            return

        for node in func(context, root):
            # It's not clear how, if it all, advanced rules should be silenced
            # by attributes (i.e., where do you put the @chplcheck.ignore
            # attribute?). For now, do not silence them on a per-node basis.

            yield (node, name)

    def basic_rule(self, pat):
        """
        This method is a decorator factory for adding 'basic' rules to the
        driver. A basic rule is a function returning a boolean that gets called
        on any node that matches a pattern. If the function returns 'True', the
        node is good, and no warning is emitted. However, if the function returns
        'False', the node violates the rule.

        The name of the decorated function is used as the name of the rule.
        """

        def wrapper(func):
            self.BasicRules.append((func.__name__, pat, func))
            return func
        return wrapper

    def advanced_rule(self, func):
        """
        This method is a decorator for adding 'advanced' rules to the driver.
        An advanced rule is a function that gets called on a root AST node,
        and is expected to traverse that AST to find places where warnings
        need to be emitted.

        The name of the decorated function is used as the name of the rule.
        """

        self.AdvancedRules.append((func.__name__, func))
        return func

    def run_checks(self, context, asts):
        """
        Runs all the rules registered with this node, yielding warnings for
        all non-silenced rules that are violated in the given ASTs.
        """

        for ast in asts:
            for rule in self.BasicRules:
                yield from self._check_basic_rule(context, ast, rule)

            for rule in self.AdvancedRules:
                yield from self._check_advanced_rule(context, ast, rule)
