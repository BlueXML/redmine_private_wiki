# Private Wiki
## A RedMine plugin

This plugin is based on the existing plugin "Redmine Private  Wiki", developped  by Oleg Kandaurov
Link of the original plugin : https://github.com/f0y/redmine_private_wiki

## Features :

As original plugin :
* It allows to set individual pages of wiki as privates
* Thoses privates pages are only visibles to the roles with the right permission
* Privatize pages are also a permission

## New Features :

New features :
* Hide private wikis in index and date_index for non-authorized users 
* Add [PRIVATE] tag in index for authorized users

## Use :

To set public/private wiki page :
	Projects -> MyProject -> Wiki -> select wiki page -> set private

## Installation :

	$cd /path/to/redmine/directory/plugins
	$git clone https://github.com/BlueXML/redmine_private_wiki.git
	$bundle exec rake redmine:plugins:migrate RAILS_ENV=production

## Compatibility :
Tested for RedMine 3.3.* (Manually)

## License :
This plugin is licensed under the MIT license.




