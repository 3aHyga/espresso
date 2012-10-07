<a href="http://e.github.com/">
<img src="http://e.github.com/images/logo.png" align="right" /></a>

<h1>
<a href="http://e.github.com/">Espresso</a>
</h1>
<strong>Scalable Web Framework aimed at Speed and Simplicity</strong>

Quick Start
---

**Ready**

```bash
$ [sudo] gem install e
```

**Set**

```ruby
require 'e'

class App < E

  map '/'

  def index
    # ...
  end
end
```

**Go!**

```ruby
App.run
```

<hr/>

# Tutorial

### Intro

[Actions](https://github.com/slivu/espresso/blob/master/Intro.md#actions) |
[Controllers](https://github.com/slivu/espresso/blob/master/Intro.md#controllers) |
[Slices](https://github.com/slivu/espresso/blob/master/Intro.md#slices) |
[MVC?](https://github.com/slivu/espresso/blob/master/Intro.md#mvc)

### Routing

[Base URL](https://github.com/slivu/espresso/blob/master/Routing.md#base-url) |
[Canonicals](https://github.com/slivu/espresso/blob/master/Routing.md#canonicals) |
[Actions](https://github.com/slivu/espresso/blob/master/Routing.md#actions) |
[Actions Mapping](https://github.com/slivu/espresso/blob/master/Routing.md#actions-mapping) |
[Parametrization](https://github.com/slivu/espresso/blob/master/Routing.md#parametrization) |
[Format](https://github.com/slivu/espresso/blob/master/Routing.md#format) |
[RESTful Actions](https://github.com/slivu/espresso/blob/master/Routing.md#restful-actions) |
[Aliases](https://github.com/slivu/espresso/blob/master/Routing.md#aliases) |
[Rewriter](https://github.com/slivu/espresso/blob/master/Routing.md#rewriter)


### Setup

[Global Setup](https://github.com/slivu/espresso/blob/master/Setup.md#global-setup) |
[Setup by Name](https://github.com/slivu/espresso/blob/master/Setup.md#setup-by-name) |
[Setup by Format](https://github.com/slivu/espresso/blob/master/Setup.md#setup-by-format) |
[Remote Setup](https://github.com/slivu/espresso/blob/master/Setup.md#remote-setup)

### Workflow

[Route](https://github.com/slivu/espresso/blob/master/Workflow.md#route) |
[Params](https://github.com/slivu/espresso/blob/master/Workflow.md#params) |
[Passing Control](https://github.com/slivu/espresso/blob/master/Workflow.md#passing-control) |
[Fetching Body](https://github.com/slivu/espresso/blob/master/Workflow.md#fetching-body) |
[Halt](https://github.com/slivu/espresso/blob/master/Workflow.md#halt) |
[Redirect](https://github.com/slivu/espresso/blob/master/Workflow.md#redirect) |
[Reload](https://github.com/slivu/espresso/blob/master/Workflow.md#reload) |
[Streaming](https://github.com/slivu/espresso/blob/master/Workflow.md#streaming) |
[Error Handlers](https://github.com/slivu/espresso/blob/master/Workflow.md#error-handlers) |
[Hooks](https://github.com/slivu/espresso/blob/master/Workflow.md#hooks) |
[Authorization](https://github.com/slivu/espresso/blob/master/Workflow.md#authorization) |
[Sessions](https://github.com/slivu/espresso/blob/master/Workflow.md#sessions) |
[Flash](https://github.com/slivu/espresso/blob/master/Workflow.md#flash) |
[Cookies](https://github.com/slivu/espresso/blob/master/Workflow.md#cookies) |
[Content Type](https://github.com/slivu/espresso/blob/master/Workflow.md#content-type) |
[Charset](https://github.com/slivu/espresso/blob/master/Workflow.md#charset) |
[Cache Control](https://github.com/slivu/espresso/blob/master/Workflow.md#cache-control) |
[Expires](https://github.com/slivu/espresso/blob/master/Workflow.md#expires) |
[Last Modified](https://github.com/slivu/espresso/blob/master/Workflow.md#last-modified) |
[Accepted Content Type](https://github.com/slivu/espresso/blob/master/Workflow.md#accepted-content-type) |
[Cache Manager](https://github.com/slivu/espresso/blob/master/Workflow.md#cache-manager) |
[Send File](https://github.com/slivu/espresso/blob/master/Workflow.md#send-file) |
[Send Files](https://github.com/slivu/espresso/blob/master/Workflow.md#send-files) |
[Attachment](https://github.com/slivu/espresso/blob/master/Workflow.md#attachment) |
[Headers](https://github.com/slivu/espresso/blob/master/Workflow.md#headers)


### View API

[Engine](https://github.com/slivu/espresso/blob/master/ViewAPI.md#engine) |
[Extension](https://github.com/slivu/espresso/blob/master/ViewAPI.md#extension) |
[Templates Path](https://github.com/slivu/espresso/blob/master/ViewAPI.md#templates-path) |
[Layouts Path](https://github.com/slivu/espresso/blob/master/ViewAPI.md#layouts-path) |
[Layout](https://github.com/slivu/espresso/blob/master/ViewAPI.md#layout)
<br/>
[Rendering Templates](https://github.com/slivu/espresso/blob/master/ViewAPI.md#rendering-templates) |
[Rendering Layouts](https://github.com/slivu/espresso/blob/master/ViewAPI.md#rendering-layouts) |
[Ad hoc Rendering](https://github.com/slivu/espresso/blob/master/ViewAPI.md#ad-hoc-rendering) |
[Templates Compilation](https://github.com/slivu/espresso/blob/master/ViewAPI.md#templates-compilation)

### CRUD

[Intro](https://github.com/slivu/espresso/blob/master/CRUD.md#intro) |
[Resource](https://github.com/slivu/espresso/blob/master/CRUD.md#resource) |
[Excluded Params](https://github.com/slivu/espresso/blob/master/CRUD.md#excluded-params) |
[Root](https://github.com/slivu/espresso/blob/master/CRUD.md#root) |
[Response](https://github.com/slivu/espresso/blob/master/CRUD.md#response) |
[Access Restriction](https://github.com/slivu/espresso/blob/master/CRUD.md#access-restriction)

### Deploy

[Controllers](https://github.com/slivu/espresso/blob/master/Deploy.md#controllers) |
[Slices](https://github.com/slivu/espresso/blob/master/Deploy.md#slices) |
[Roots](https://github.com/slivu/espresso/blob/master/Deploy.md#roots) |
[Run](https://github.com/slivu/espresso/blob/master/Deploy.md#run) |
[config.ru](https://github.com/slivu/espresso/blob/master/Deploy.md#configru)

<hr/>

# Highlights / Motivation


Performance
---

In terms of performance, the only really important thing for any framework it is to add as low overhead as possible.

The overhead are the time consumed by framework to accept the request then prepare and send response.

The tests that follows will allow to disclose the overhead added by various frameworks.

The overhead are calculated by dividing 1000 milliseconds to **framework’s standard speed**.

The **framework’s standard speed** are the speed of HelloWorld app running on top of given framework.

The **framework’s standard speed** means nothing by itself. It is only used to calculate the framework’s overhead.

Tested apps will run on Thin web server and will return a trivial "Hello World!" response.

Hardware used:

    Processor Name: Intel Core i5
    Processor Speed: 3.31 GHz
    Number of Processors: 1
    Total Number of Cores: 4
    Memory: 8 GB

To run tests on your hardware, clone Espresso Framework repository and execute `rake overhead` inside it.

Test results:

    ---
                Speed  Overhead  1ms-app  5ms-app  10ms-app  20ms-app  50ms-app  100ms-app
      espresso  5518   0.18ms    847      193      98        49        19        9
       sinatra  3629   0.28ms    783      189      97        49        19        9
         rails  792    1.26ms    442      159      88        47        19        9
    ---

**1ms-app** shows your app speed when your actions takes **1ms** to run.<br/>
**10ms-app** shows your app speed when your actions takes **10ms** to run.<br/>
etc.

The app speed are calculated as follow:

    1000 / (time taken by action + time taken by framework)

So, if your actions takes about 1ms and you use a framework with overhead of 0.18ms, the app speed will be:

    1000 / ( 1 + 0.18 ) = 847 requests per second

However, if framework's overhead is of **1ms** or more, the app speed will decrease dramatically:

    1000 / ( 1 + 1.26 ) = 442 requests per second


**Conclusions?**

The framework speed matter only if your code matter.

If you develop a site aimed to serve a serious amount of requests,
you should write actions that takes  insignificant amount of time.

Only after that it make sense to think about framework speed.

**Worth to Note** - Espresso has built-in [cache manager](https://github.com/slivu/espresso/blob/master/Workflow.md#cache-manager)
as well as [views compiler](https://github.com/slivu/espresso/blob/master/ViewAPI.md#templates-compilation).

These tools may help you to dramatically reduce the time consumed by your actions.

Natural Action/Routes/Params
---

I never understood why should i create actions in some file,
then open another file and directing requests to created action.<br/>
Even worse! To use params inside action, i have to remember how i named them in another file.
And when i want to change a param name i have to change it in both files?

What about consistency?<br/>

A good tradeoff would be to use some DSL.

```ruby
get '/book/:id' do
    params[:id]
end
```

Looks much better.

But! Strings/Regexps as action names? No, thanks.

What if i need to remount a bunch of actions to a new root?
Say from /news to /headlines? Refactoring? Using vars/constants in names? No, Thanks.

How do i setup multiple actions?<br/>
How do i find out the currently running action?

What if i do a request like "/book/100/?id=200"? What? Should i use unique param names? No, thanks.

etc. etc.

And why should i remember so many non-natural stuff?

Is not Ruby powerfull enough? I guess it is:

```ruby
def book id

end
```

That's a regular **Ruby method** and a regular **Espresso action**.<br/>
That's also an Espresso route. Yes, the app will respond to "/book/100"<br/>
And of course action params are used naturally, through method arguments(`id` rather than `params[:id]`).

And all this offered by Ruby for free! Why to reinvent the wheel?

Expressive Setup
---

Usually you do not want to instruct each action about how it should behave.

It would take eras to define inside each action what content type should it return or what layout should it render.

Instead, you will use few lines of code at class level to write instructions that will be followed by all actions.

**Example:** Instruct **all** actions under `App` controller to return JSON Content-Type

```ruby
class App < E
    content_type :json
    # ...
end
```

But what if you need to setup only specific actions?

Simple! Put your setup, well, inside `setup` block and pass action names as parameters.

**Example:** Instruct **only** `rss` and `feed` actions to return XML Content-Type

```ruby
class App < E

    setup :rss, :feed do
        content_type :xml
    end
    # ...
end
```

Well, what if i need some setup for some 10 actions ad another setup for another 20 actions?
Should i pass 30 arguments to `setup`? I do not want to buy a new keyboard every month...

That's simple too. Use regular expressions.

Ex: setup **only** news related actions:

```ruby
class App < E

    setup /news/ do
        # some setup
    end
    # ...
end
```


Slices
---

Portability and DRY done right and easy.

With Espresso, any controller can be mounted under any app.

Even more, any set of controllers - a.k.a. **slices** - can be mounted under any app.

To create a slice simply put your controllers under some module.

Then you can mount that module under any Espresso app.

Even more, when mounting you can easily setup all controllers(or some) at once.

And of course when mounting, you can give a mount point.

```ruby
module Cms

    class Articles < E
        # ...
    end

    class News < E
        # ...
    end

    class Pages < E
        # ...
    end
end

app = Cms.mount do
    # some setup that will run inside each controller
end

# or
app = Cms.mount do |ctrl|
    # some setup that will run inside controllers that match `ctrl` param
end

app.run
```

RESTful Actions
---

By default, verbless actions will respond to any request type.

To make some action to respond only to some request type,
simply prepend the corresponding verb to the action name.

```ruby
# will respond to any request type
def book
    # ...
end

# GET
def get_book
    # ...
end

# POST
def post_book
    # ...
end

# PUT
def put_book
    # ...
end

# etc.
```


Flexible Rewriter
---

With Espresso built-in rewriter you can redirect any requests to new URL.

However, beside trivial redirects, rewriter can also pass the control to an arbitrary controller#action
or simply halt the request and send the response.

Views Compiler
---

For most web sites, most time are spent at templates rendering.<br/>
When rendering templates, most time are spent at reading and compiling.

Espresso allow to easily skip these expensive operations by keeping compiled templates in memory
and just render them on consequent requests.

Cache
---

If you have some expensive operations that basically return static data,
simply put them inside `cache` block.

The result will be cached and returned on consequent requests.

To clear cache, simply call `clear_cache!`
