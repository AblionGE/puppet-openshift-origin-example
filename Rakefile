require 'rake'
require 'rake/tasklib'
require 'r10k/puppetfile'
require 'net/https'

base_vagrant = "/vagrant/"
librarian_modulepath = File.join(base_vagrant, "librarian_modules")
modulepath = File.join(base_vagrant, "modules")
site_pp = File.join(base_vagrant, "site.pp")

task :default => [:help]

task :help do
    system("rake -T")
end

namespace :test do
    desc 'test the puppet file syntax, the hiera file and the puppetfile'
    task :test do
        puts("checking modules syntax errors")
        Dir.glob("modules/**/*.pp").each do | puppet_file |
             sh("puppet parser validate #{puppet_file}")
    end
    puts("checking hiera syntax errors")
        Dir.glob("hieradata/{**/,}*.e?yaml").each do | hiera_file |
            sh "yamlcheck #{hiera_file}"
        end
        puts("checking puppetfile syntax errors")
        system("r10k puppetfile  check")
    end
    desc 'run the linter'
    task :lint do
        puts("Now checking the linter")
        system("puppet-lint --no-80chars-check --with-filename modules/")
    end
end

directory "manifests"

desc 'Build rdoc documentation.'
task :doc => 'manifests' do
    cwd = Dir.pwd
    manifest_dir = "#{cwd}/manifests"
    module_path = "#{cwd}/modules"
    system("puppet doc --mode rdoc --manifestdir #{manifest_dir} --modulepath #{module_path}")
end

desc 'Deploy a production environment'
namespace :prod do
    desc 'update the environements, should be run as root'
    task :update do 
        Dir.chdir "/etc/puppet/" do
            sh 'sudo -u puppet /usr/local/bin/r10k deploy environment -p'
            sh 'foreman-rake puppet:import:puppet_classes[batch]'
        end
    end
end

desc 'Deploy a dev environment'
namespace :dev do
    namespace :deploy do
        desc "Deploy a generic os with a name and a version number, this function doesn't do any check"
        task :os, [:os,  :version] do |caller, args|
            os_name = args[:os]
            version = args[:version]
            sh "vagrant init puppetlabs/#{os_name}-#{version}-64-puppet"
        end
        desc 'Deploy a centos os, with version 7'
        task :centos_7 do
                Rake::Task['dev:deploy:os'].invoke('centos', 7.0)
        end
        desc 'Deploy a centos os, with version 6'
        task :centos_6 do
                Rake::Task['dev:deploy:os'].invoke('centos', 6.6)
        end
        desc 'Deploy a centos os, with version 5'
        task :centos_5 do
                Rake::Task['dev:deploy:os'].invoke('centos', 5.11)
        end
        desc 'Deploy an ubuntu os, with version 14.04'
        task :ubuntu_14_04 do
                Rake::Task['dev:deploy:os'].invoke('ubuntu', 14.04)
        end
        desc 'Deploy an ubuntu os, with version 14.10'
        task :ubuntu_14_10 do
                Rake::Task['dev:deploy:os'].invoke('ubuntu', 14.10)
        end
    end
    desc "halt the vm"
    task :halt do
        sh "vagrant halt"
    end
    desc "start the vm"
    task :up do
        sh "vagrant up"
    end
    desc "restart the vm"
    task :reload do
        sh "vagrant reload"
    end
    desc "apply the puppet module defined in the site.pp"
    task :apply_site => :up do
        sh "vagrant ssh -c 'cd /tmp && sudo puppet apply --modulepath #{modulepath}:#{librarian_modulepath} #{site_pp}'"
    end
    desc "apply the puppet module defined in the site.pp for a specific host (hosts should be defined manually in the Vagrantfile)"
    task :apply_host, [:host] => :up do |caller, args|
        host = args[:host]
        sh "vagrant ssh #{host} -c 'cd /tmp && sudo puppet apply --modulepath #{modulepath}:#{librarian_modulepath} #{site_pp}'"
    end
    desc "apply a given role to the node"
    task :apply_role, [:role] => :up do |caller, args|
        role = args[:role]
        sh "vagrant ssh -c 'sudo puppet apply --modulepath #{modulepath}:#{librarian_modulepath} -e include\\ role::#{role}'"
    end
    desc "apply any string to the node as if it were puppet code"
    task :apply, [:manifest] => :up do |caller, args|
        manifest = args[:manifest]
        escaped_manifest = Shellwords.shellescape(manifest)
        sh "vagrant ssh -c 'sudo puppet apply --modulepath #{modulepath}:#{librarian_modulepath} -e #{escaped_manifest}'"
    end
    desc "destroy the vagrant box and destroy the corresponding Vagrantfile"
    task :cleanup do 
        sh "vagrant destroy -f"
        File.delete("Vagrantfile")
    end
end

desc 'Manipulate the dependencies'
namespace :dependencies do 

    directory "librarian_modules"

    desc "update the dependencies"
    task :deploy => 'librarian_modules' do
        sh 'r10k puppetfile install'
    end
    desc "purge the existing puppet module"
    task :purge => 'librarian_modules' do
        sh 'r10k puppetfile purge'
    end
    desc "Remove the external dependencies, and the corresponding directory"
    task :remove do
        sh 'rm -Rv librarian_modules'
    end
    desc "Check outdated forge modules"
    task :check_outdated do
        puppetfile = R10K::Puppetfile.new(".").load()
        puppetfile.each do |puppet_module|
            if puppet_module.class == R10K::Module::Forge
              module_name = puppet_module.title.gsub('/', '-')
              uri = URI.parse("https://forgeapi.puppetlabs.com/v3/modules/#{module_name}")
              http = Net::HTTP.new(uri.host, uri.port)
              http.use_ssl = true
              request = Net::HTTP::Get.new(uri.request_uri)
              body = http.request(request).body
              forge_version = JSON.parse(body)['current_release']['version']
              installed_version = puppet_module.expected_version
              if installed_version != forge_version
                puts "#{puppet_module.title} is OUTDATED: #{installed_version} vs #{forge_version}"
              end
            end
        end
    end
end
