require 'facter'

Facter.add('root_mail_alias') do
    setcode '/usr/sbin/postmap -q root hash:/etc/aliases'
end
