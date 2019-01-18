# Copyright 2019 The Kythe Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO(schroederc): move reusable chunks of verifier_test.bzl here

def _merge_kzips_impl(ctx):
    output = ctx.outputs.kzip
    ctx.actions.run(
        outputs = [output],
        inputs = ctx.files.srcs,
        executable = ctx.executable._kzip,
        mnemonic = "MergeKZips",
        arguments = ["merge", "--output", output.path] + [f.path for f in ctx.files.srcs],
    )
    return struct(files = depset([output]))

merge_kzips = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        ),
        "_kzip": attr.label(
            default = Label("//kythe/go/platform/tools/kzip"),
            executable = True,
            cfg = "host",
        ),
    },
    outputs = {"kzip": "%{name}.kzip"},
    implementation = _merge_kzips_impl,
)