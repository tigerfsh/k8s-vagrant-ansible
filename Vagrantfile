IMAGE_NAME = "bento/ubuntu-16.04"
N = 2

# Vagrant.configure(2) do |config|
#     # ～省略～

#     # プロキシ設定
#     if Vagrant.has_plugin?("vagrant-proxyconf")
#         config.proxy.http     = "http://{proxy_ip}:{proxy_port}"
#         config.proxy.https    = "http://{proxy_ip}:{proxy_port}"
#         config.proxy.no_proxy = "localhost,127.0.0.1"
#     end
# end

Vagrant.configure("2") do |config|
    # if Vagrant.has_plugin?("vagrant-proxyconf")
    #     config.proxy.http     = "http://192.168.1.3:1081"
    #     config.proxy.https    = "http://192.168.1.3:1081"
    #     config.proxy.no_proxy = "localhost,127.0.0.1,192.168.50.10,192.168.50.11,192.168.50.12,192.168.0.0/16,10.96.0.0/12"
    #     # config.proxy.enabled = {docker: true}
    #     # config.apt_proxy.http = "http://192.168.1.3:1081"
    #     # config.apt_proxy.https = "http://192.168.1.3:1081"
    # end

    config.ssh.insert_key = false
    config.vm.synced_folder "share", "/home/vagrant/share", create: true
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
    end
      
    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", ip: "192.168.1.6"
        master.vm.hostname = "k8s-master"
        # master.vm.provision "ansible" do |ansible|
        #     ansible.playbook = "kubernetes-setup/master-playbook.yml"
        #     ansible.extra_vars = {
        #         node_ip: "192.168.50.10",
        #     }
        # end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "public_network", ip: "192.168.1.#{i + 6}"
            node.vm.hostname = "node-#{i}"
            # node.vm.provision "ansible" do |ansible|
            #     ansible.playbook = "kubernetes-setup/node-playbook.yml"
            #     ansible.extra_vars = {
            #         node_ip: "192.168.50.#{i + 10}",
            #     }
            # end
        end
    end
end
