## Ruby Test Task
**Site for demo bank data** `https://demo.bank-on-line.ru/`

**Platform** `Windows 10`

**Ruby** `2.7.2`

**Ide** `RubyMine`

**Watir** `6.17.0`

**Nokogiri** `1.10.10`
##

## FYI
1. **_Run `bundle install` in the root of the project to extract all needed gems for the script, some may not be included by default_**

2. **_run `accounts.rb`_**

3. **_output will be written into `output.json` _in the root of the project_ _**

## TODO:
 * **implement unit-testing of main methods**: _will be implemented in further commits_
 * **~~apply code style and code refactor~~**: _DONE_
 * **~~format script output to proper JSON format~~**: _DONE_
 * **~~Fix the block code above~~**: _DONE_
 ```ruby 
     browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_number}/Transactions"
     browser.span(id: 'getTranz').click
     sleep(5) #TODO find another way for the watir html extraction delay
 ```


## Documentation:
`"Head First" - O'Reilly`
 
`Tutorials from Test Task description`
 
 ## Difficulties:
 * _problems with ffi extension, did not notice it should be installed as a separate gem module_
 * _had problems to connect the implementation of data extraction via **watir** and **nokogiri** parsing_