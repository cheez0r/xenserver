#
# Cookbook Name:: xenserver
# Recipe:: create_instances
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

# curl is used to download the .xva
package "curl"

node[:xenserver][:instances].each do |instance|
    
  file_data_array = instance["file_data_array"]
  file_data_array = [] if file_data_array.nil?
  if not instance[:inject_dom0_authorized_keys].nil? and instance[:inject_dom0_authorized_keys] == 'true' then
    # copy the authorized keys from the dom0 into the domU
    file_data_array << {
                       'filename' => "/root/.ssh/authorized_keys",
                       'data' => IO.read("/root/.ssh/authorized_keys")
                       }
  end

  create_instance instance["hostname"] do
    #common params
    image_path instance["image_path"] if instance["image_path"]
    xva_image_url instance["xva_image_url"] if instance["xva_image_url"]
    mac instance["mac"]
    # openstack guest agent params
    file_data_array file_data_array
    ip_address instance["ip_address"]
    broadcast instance["broadcast"]
    netmask instance["netmask"]
    dns_nameservers instance["dns_nameservers"]
    gateway instance["gateway"]
    # dhcp params
    use_dhcp instance["use_dhcp"]
    xen_bridge instance["xen_bridge"]
  end

end
