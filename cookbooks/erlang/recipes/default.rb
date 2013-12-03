apt_repository 'erlang-solutions' do
    uri          'http://packages.erlang-solutions.com/debian'
    distribution node['lsb']['codename']
    components   ['contrib']
    key          'http://packages.erlang-solutions.com/debian/erlang_solutions.asc'
end

#package "erlang-base-hipe"
#package "erlang"
package "esl-erlang"

package "erlang-manpages"
