#!/usr/bin/env python3

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
import chapel.replace
import sys
import argparse
from driver import LintDriver
from rules import register_rules
from lsp import run_lsp

def print_violation(node, name):
    location = node.location()
    first_line, _ = location.start()
    print("{}:{}: node violates rule {}".format(location.path(), first_line, name))

def main():
    parser = argparse.ArgumentParser( prog='chplcheck', description='A linter for the Chapel language')
    parser.add_argument('filenames', nargs='*')
    parser.add_argument('--disable-rule', action='append', dest='disabled_rules', default=[])
    parser.add_argument('--enable-rule', action='append', dest='enabled_rules', default=[])
    parser.add_argument('--lsp', action='store_true', default=False)
    args = parser.parse_args()

    driver = LintDriver()
    driver.disable_rules("CamelCaseVariables", "ConsecutiveDecls")
    driver.disable_rules(*args.disabled_rules)
    driver.enable_rules(*args.enabled_rules)
    register_rules(driver)

    if args.lsp:
        run_lsp(driver)
        return

    for (filename, context) in chapel.files_with_contexts(args.filenames):
        asts = context.parse(filename)
        for (node, rule) in driver.run_checks(context, asts):
            print_violation(node, rule)

if __name__ == "__main__":
    main()
