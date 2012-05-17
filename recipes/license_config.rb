#
# Cookbook Name:: xenserver
# Recipe:: license_config
#
# Copyright 2011, Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


license_filename=node[:xenserver][:license_filename]

template license_filename do
  source "license.txt.erb"
  variables(
    :b64_license_data => node[:xenserver][:b64_license_data]
  )
end

bash "add host license" do
  action :nothing
  user "root"
  code <<-EOH
	UUID=$(xe host-list | grep uuid | sed -e 's|.*: ||')
	xe host-license-add host-uuid=$UUID license-file=#{license_filename}
  EOH
  subscribes :run, resources("template[#{license_filename}]"), :immediately
end
