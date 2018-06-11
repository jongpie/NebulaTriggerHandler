# Nebula Trigger Framework
[![Travis CI](https://img.shields.io/travis/jongpie/NebulaTriggerFramework/master.svg)](https://travis-ci.org/jongpie/NebulaTriggerFramework)

<a target="_blank" href="https://githubsfdeploy.herokuapp.com">
    <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

## Features
* Implements Salesforce best practices of 1 trigger per object & logicless triggers
* The abstract class SobjectTriggerHandler.cls handles determining the current context and calling 1 of 7 protected methods - triggers only have to call the public execute() method
* Provides recursion detection/prevention by checking the list of trigger records have already been processed
* Allows triggers to be enabled/disabled both globally and individually at the org, profile and user levels (hierarchy custom setting)
* Allows framework debug statements to be enabled/disabled
* Recursion prevention: in the event that there is a recursive loop, each handler detects that it has already processed the records and skips duplicated execution