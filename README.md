# Ruby Test Task

**Site for demo bank data** `https://demo.bank-on-line.ru/`

**Platform** `Windows 10`

**Ruby** `2.7.2`

**Ide** `RubyMine`

**Watir** `6.17.0`

**Nokogiri** `1.10.10`


> Decided to make the implementation in 2 separate files for **Watir** and **Nokogiri**.
> will need to understand your code. Be generous — the next one may be you!

>Though I understand that the task should be done in different steps and these steps to be followed via github commits.


**Commit**: `https://github.com/amoscaliuc/ruby-test-task/commit/9a776a2b3a9912e36be78511181c7617138eec30`
> Contains the _**version #1**_ of the implementation, just on the basis of info gained from tutorials about Ruby

**Commit**: `https://github.com/amoscaliuc/ruby-test-task/commit/2b0da86532af1305fcd6c527505f122d7ff0588c`
> Contains the _**version #2**_ of the implementation via class and code styles applied

#### FYI
1. **_Run `bundle install` in the root of the project to extract all needed gems for the script, some may not be included by default_**

2. **_For Watir implementation run `accountsWatir.rb`_**

3. **_For Nokogiri implementation run `accountsNokogiri.rb`_**

> Skip `samples` folder, i.e. just for personal practicing non functionally related to test task!

#### TODO:
 * **implement unit-testing of main methods**: _will be implemented in further commits_
 * **~~apply code style and code refactor~~**: _DONE_
 * **format script output to proper JSON format**: -
 * **Fix the block code above**: 
 ```ruby 
     browser.goto "https://demo.bank-on-line.ru/#Contracts/#{account_number}/Transactions"
     browser.span(id: 'getTranz').click
     sleep(5) #TODO find another way for the watir html extraction delay
 ```

**Documentation:**

`"Head First" - O'Reilly`
 
`Tutorials from Test Task description`
 
 #### Difficulties:
 * _problems with ffi extension, did not notice it should be installed as a separate gem module_
 * _had problems to connect the implementation of data extraction via **watir** and **nokogiri** parsing_