apt_repository 'pgdg' do
    uri          'http://apt.postgresql.org/pub/repos/apt/'
    distribution "#{node['lsb']['codename']}-pgdg"
    components   ['main']
    key          'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
end

# Setup locale before installing postgresql otherwise we end up with latin1 encoded databases
execute "update-locale LANG=en_US.utf8 LC_ALL=en_US.utf8"

package "postgresql-9.3"
package "postgresql-contrib-9.3"
