---
title: 手把手教你基于ES6架构自己的React Boilerplate项目
layout: post
date: 2016-4-21 20:10
comments: true
tags: [前端]
---


# 前言

React技术之火爆无须多言，其与webpack的完美结合，也让二者毋庸置疑的成为天生一对。为了进行React的快速和规范化开发，开源社区中涌现了很多React+webpack的boilerplate项目。通过使用这些boilerplate，我们可以快速的创建一个React项目的架构。

我专门创建了一个Github项目用于收集这些boilerplate：[awesome-react-boilerplate](http://jiji262.github.io/awesome-react-boilerplate/)。当然这里不可能完整收录，但是目前为止已经有近30个了。连boilerplate都这么多，真让我们眼花缭乱，无从下手。

当然，由于每个人的使用习惯和技术背景的不同，每个boilerplate都会有自己的侧重点，因此即便是公认比较好的boilerplate项目也未必适合所有人。笔者相信，只有适合自己的，才是最好的。这就是本文的初衷，笔者会追根溯源，从没有开发环境的蛮荒阶段开始，搭建开发环境，配置webpack，在React项目中使用webpack，搭建React项目的测试环境，一步一步构建适合自己的React + webpack起始项目。


### 将使用的技术栈

- React
- webpack
- babel
- ES6



# webpack快速入门

## webpack介绍

Webpack是一个前端模块管理工具，有点类似browserify，出自Facebook的Instagram团队，但功能比browserify更为强大，可以说是目前最为强大的前端模块管理和打包工具。

Webpack将项目中的所有静态资源都当做模块，模块之间可以互相依赖，由webpack对它们进行统一的管理和打包发布，下图为官方网站说明：

![web pack](http://webpack.github.io/assets/what-is-webpack.png)

webpack对React有着与生俱来的支持，随着React的流行，webpack也成了React项目中必不可少的一部分。特别是随着ES6的普及，使得webpack有了更广阔的用武之地。

## 安装配置webpack

### 安装nodejs

安装webpack之前，需要确认本机已经安装好了nodejs。

如果还没有安装，请去[nodejs官网](https://nodejs.org)下载安装即可。这里使用的node版本是V4.4.1.

### 初始化项目环境

```
$ mkdir react_boilerplate
$ cd react_boilerplate\

$ npm init -y
Wrote to D:\node\react_boilerplate\package.json:

{
  "name": "react_boilerplate",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}

```

`npm init` 加上一个`-y`选项会生成一个默认的`package.json`,关于这个文件，不是本文重点，在此不会详述，可以参考[官方文档](https://docs.npmjs.com/files/package.json)。可以简单的理解，这个文件是用于管理项目里面的依赖包的。

### 设置.gitignore

如果我们使用git进行版本管理，一个.gitignore文件是必要的。这里我们可以先将项目需要安装的node包目录添加进去。

```
node_modules
```

使用`npm install`安装的node包都会在`node_modules`目录下，这个目录是不需要commit到git的。


### 安装webpack

安装webpack很简单，命令如下：

```
npm i webpack --save-dev
```

其中`--save-dev`表示该包为开发环境依赖包。安装完后会生成一个`node_modules`目录，并且在`package.json`文件中多出如下几行：

```
......
  "devDependencies": {
    "webpack": "^1.13.0"
  }
}

```

如果写为`--save`则表示该包为生产环境依赖包，在`package.json`文件中会新增或者修改`dependencies` 字段。

### 初始化项目结构和代码

安装完`webpack`后，我们可以给项目中增加一些内容了。项目的简单结构如下图所示：

![](image here)

`app`目录用于存放项目代码，`dist`目录为编译后的项目文件，`webpack.config.js`为`webpack`的配置文件。

我们给项目中的文件添加一些简单的代码，首先是组件代码：

##### app/component.js
```
module.exports = function () {
  var element = document.createElement('h1');

  element.innerHTML = 'Hello world';

  return element;
};
```

然后需要一个入口文件，在入口文件中使用上面定义的组件：

##### app/index.js
```
var component = require('./component');

document.body.appendChild(component());
```


### 配置webpack

我们需要让webpack知道如何处理我们的项目目录结构，因此需要配置文件`webpack.config.js`。一个简单的配置文件如下所示：

```
var webpack = require('webpack'); 
var path = require('path');                 //引入node的path库

var config = {
  entry: ['./app/index.js'],                //入口文件
  output: {
    path: path.resolve(__dirname, 'dist'),  // 指定编译后的代码位置为 dist/bundle.js
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      // 为webpack指定loaders
      //{ test: /\.js$/, loaders: ['babel'], exclude: /node_modules/ }   
    ]
  }
}

module.exports = config;
```

到目前为止，我们已经可以让webpack工作了，在命令行执行

```
webpack
```

我们看到，会有一个新的文件`/dist/bundle.js`生成出来了。但是我们还需要一个html文件来加载编译后的代码，这就需要用到一个webpack插件：`html-webpack-plugin`。

### 安装`html-webpack-plugin`

使用如下命令安装：

```
npm install html-webpack-plugin --save-dev
```

然后在我们的`webpack.config.js`中增加下面几行：
```
  plugins: [
    new HtmlwebpackPlugin({
      title: 'React Biolerplate by Linghucong'
    })
  ]
```
现在在命令行下再次执行`webpack`命令，会看到在`dist`目录下生成了两个文件：`bundle.js`和`index.html`。其中`index.html`内容如下：

##### dist/index.html
```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>React Biolerplate by Linghucong</title>
  </head>
  <body>
  <script src="bundle.js"></script></body>
</html>
```

有必要提一下，如果我们安装webpack的时候使用的是全局安装选项（`npm install -g webpack`），可以在命令行中直接执行`webpack`命令；如果没有使用`-g`，那么要用的`webpack`可执行文件位于：
```
./node_modules/.bin/webpack
```

我们可以在`package.json`中为此命令增加一个快捷方式：

```
# package.json
... other stuff
"scripts": {
  "build": "./node_modules/.bin/webpack"
}
```

现在就可以直接使用命令`npm run build`来执行webpack了。

```
$ npm run build

> react_boilerplate@1.0.0 build D:\node\react_boilerplate
> webpack

Hash: cbf754a65493b4d791d7
Version: webpack 1.13.0
Time: 919ms
     Asset       Size  Chunks             Chunk Names
 bundle.js     233 kB       0  [emitted]  main
index.html  179 bytes          [emitted]
   [0] multi main 52 bytes {0} [built]
  [75] ./app/index.js 82 bytes {0} [built]
  [76] ./app/component.js 142 bytes {0} [built]
    + 74 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```

### 安装`webpack-dev-server`

`webpack-dev-server`可以让我们在本地启动一个web服务器，使我们更方便的查看正在开发的项目。其安装也十分简单：

```
npm i webpack-dev-server --save-dev
```

然后在`webpack.config.js`文件中作如下修改：
```
# webpack.config.js
# ...
  entry: [
    'webpack/hot/dev-server',
    'webpack-dev-server/client?http://localhost:3000',
    './app/index.js'      //入口文件
    ],  
# ...
```

我们可以在`package.json`中增加`webpack-dev-server`的快捷方式：

```
# package.json
... other stuff
"scripts": {
  "dev": "webpack-dev-server --port 3000 --devtool eval --progress --colors --hot --content-base dist",
  "build": "./node_modules/.bin/webpack"
}
```

配置中指定web服务器端口号为3000，指定目录为dist。
运行`npm run dev`：
```
$ npm run dev

> react_boilerplate@1.0.0 dev D:\node\react_boilerplate
> webpack-dev-server --port 3000 --devtool eval --progress --colors --hot --content-base dist

......
Time: 1109ms
     Asset       Size  Chunks             Chunk Names
 bundle.js     274 kB       0  [emitted]  main
index.html  179 bytes          [emitted]
chunk    {0} bundle.js (main) 216 kB [rendered]
    [0] multi main 52 bytes {0} [built]
 ......
 ......
 ......
   [77] ./app/component.js 142 bytes {0} [built]
Child html-webpack-plugin for "index.html":
    chunk    {0} index.html 505 kB [rendered]
        [0] ./~/html-webpack-plugin/lib/loader.js!./~/html-webpack-plugin/default_index.ejs 540 bytes {0} [buil
t]
        [1] ./~/lodash/lodash.js 504 kB {0} [built]
        [2] (webpack)/buildin/module.js 251 bytes {0} [built]
webpack: bundle is now VALID.

```

web服务器启动完毕，此时访问 http://localhost:3000/ 就可以看到我们的“Hello world”了。
![]()

需要特别说明的是，`webpack-dev-server`是支持热加载的，也就是说我们对代码的改动，保存的时候会自动更新页面。比如我们在文件中将“Hello world”改为“Linghucong”，会看到页面实时更新了，无须再按F5刷新，爽吧？！
![]()

`webpack-dev-server`的配置还可以放在`webpack.config.js`中，需要使用一个`devServer`属性，详细可以[参考官方文档](https://webpack.github.io/docs/webpack-dev-server.html)。

### 处理CSS样式

项目中使用CSS是必不可少的。webpack中使用loader的方式来处理各种各样的资源，根据设定的规则，会找到相应的文件路径，然后使用各自的loader来处理。CSS文件也需要特定的loader，一般需要使用两个：`css-loader`和 `style-loader`，如果使用LESS或者SASS还需要加载对应的loader。这里我们使用LESS，因此安装loaders:

```
npm install css-loader style-loader less-loader --save-dev
```

踩坑提醒，npm3.0以上需要单独安装less：`npm install less --save-dev`。

然后在文件`webpack.config.js`中配置：
```
      {
        test: /\.less$/,
        loaders: ['style', 'css', 'less'],
        include: path.resolve(__dirname, 'app')
      }
```      

可以看到，test里面包含一个正则，包含需要匹配的文件，loaders是一个数组，包含要处理这些文件的loaders，注意loaders的执行顺序是从右到左的。

新建一个LESS文件`/app/index.less`，其内容如下：
```
h1 {
    color: green;
}
```

在入口文件`index.js`中引入这个文件：
```
require('./index.less');
```

然后运行webpack进行编译：`npm run build`:
```
$ npm rrun build

> react_boilerplate@1.0.0 build D:\node\react_boilerplate
> webpack

Hash: 0c25c4bacdc334db1e04
Version: webpack 1.13.0
Time: 1902ms
     Asset       Size  Chunks             Chunk Names
 bundle.js     243 kB       0  [emitted]  main
index.html  179 bytes          [emitted]
   [0] multi main 52 bytes {0} [built]
  [75] ./app/index.js 110 bytes {0} [built]
  [80] ./app/component.js 141 bytes {0} [built]
    + 78 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
```  

可以看到， http://localhost:3000/ 页面上的文字已经变成绿色了。
![]()

到目前为止的代码可以在[react_boilerplate _v1]()中查看。

# webpack 支持ES6

## Javascript包管理格式

Javascript中的包管理比较常见的有几种方式：

#### CommonJS

```
//CommonJS 定义的是模块的同步加载，主要用于NodeJS

var MyModule = require('./MyModule');

// export at module root
module.exports = function() { ... };

// alternatively, export individual functions
exports.hello = function() {...};

```

#### AMD

```
//AMD 是异步加载，比如require.js使用这种规范
define(['./MyModule.js'], function (MyModule) {
  // export at module root
  return function() {};
});

// or
define(['./MyModule.js'], function (MyModule) {
  // export as module function
  return {
    hello: function() {...}
  };
});

```

#### ES6
```
//ES6 变得越来越主流了

import MyModule from './MyModule.js';

// export at module root
export default function () { ... };

// or export as module function,
// you can have multiple of these per module
export function hello() {...};

```

还有其他格式如UMD、CMD等，在此不再一一介绍。webpack对这些模块格式都可以很好的支持。在我们之前的项目中使用的是CommonJS格式的模块管理，但是随着ES6的普及和应用，同时得益于强大的[Babel](https://babeljs.io/)的存在，使我们可以方便的使用ES6的语法，而不必考虑浏览器支持的问题。

## webpack支持ES6语法

在webpack中支持ES6同样只需要安装配置相应的loader就可以了。

安装如下：

```
npm install babel-loader babel-core babel-preset-es2015 babel-preset-react --save-dev
```

在`webpack.config.js`中添加loader如下：
```
  { 
    test: /\.jsx?$/, 
    loader: 'babel', 
    exclude: /node_modules/,
    query: {
      presets: ['react', 'es2015'] 
    }
  } 
```
由于后边需要支持React的jsx文件，所以我们在这里安装了`babel-preset-react`。

顺便提一下，我们可以在项目根目录下创建一个`.babelrc`文件，将loader中的`presets`放在文件`.babelrc`中：
```
# .babelrc
{
  "presets": ["react", "es2015"]
}
```

此时我们运行`npm run build`，正常编译后，使用`npm run dev`，启动web服务器，打开 http://localhost:3000/ 可以看到页面已经可以正常显示了。

**踩坑提醒**

如果上面对于loader的配置写为（注意这里是`loaders`不是`loader`）：
```
{ 
    test: /\.jsx?$/, 
    loaders: ['babel'], 
    exclude: /node_modules/,
    query: {
      presets: ['es2015', 'react'] 
    }
}
```
则可能会出现这样的错误：
```
$ npm run build

> react_boilerplate@1.0.0 build D:\node\react_boilerplate
> webpack

D:\node\react_boilerplate\node_modules\webpack-core\lib\LoadersList.js:54
                if(!element.loader || element.loader.indexOf("!") >= 0) throw new Error("Cannot define 'query' and multiple loaders in loaders list");
                                                                        ^

Error: Cannot define 'query' and multiple loaders in loaders list
    at getLoadersFromObject (D:\node\react_boilerplate\node_modules\webpack-core\lib\LoadersList.js:54:65)
    at LoadersList.<anonymous> (D:\node\react_boilerplate\node_modules\webpack-core\lib\LoadersList.js:78:12)
    at Array.map (native)
    at LoadersList.match 
    ...

```

原因是使用了多个`loader`，而`query`仅仅作用于`babel-loader`。如果非要使用`loaders`加载多个`loader`，可以做如下修改：
```
var babelPresets = {presets: ['react', 'es2015']};
......
loaders: ['other-loader', 'babel-loader?'+JSON.stringify(babelPresets)]
......
```

到目前为止的代码可以在[react_boilerplate _v2]()中查看。

# 在项目中支持使用React

关于React的介绍和基本概念相信你已经有所了解，如果需要，可以参考本文最后的“参考阅读”中的链接，在此不再详述。

## 安装React

```
npm install react react-dom --save
```

这里我们使用的版本是15.0.1。
```
$ npm install react react-dom --save
react_boilerplate@1.0.0 D:\node\react_boilerplate
+-- react@15.0.1
| `-- fbjs@0.8.1
|   +-- isomorphic-fetch@2.2.1
|   | +-- node-fetch@1.5.1
|   | | +-- encoding@0.1.12
|   | | | `-- iconv-lite@0.4.13
|   | | `-- is-stream@1.1.0
|   | `-- whatwg-fetch@0.11.0
|   `-- ua-parser-js@0.7.10
`-- react-dom@15.0.1
```

## 改造项目结构

在项目中我们使用了html-webpack-plugin插件来用webpack自动生成入口的index.html文件，但是里面的内容我们没法控制。html-webpack-plugin提供了一种模板的机制，可以让我们对生成的文件内容进行定制。

### 创建模板文件

我们使用一个新的目录templates用于存放模板文件，新建一个index.ejs文件：

##### templates/index.ejs
```
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
    <title><%= htmlWebpackPlugin.options.title %></title>
  </head>
  <body>
  <h3>Welcome to New Page</h3>
  <div id="content"></div>
  </body>
</html>
```

### 修改 html-webpack-plugin 设置

修改`webpack.config.js`文件如下：
```
  plugins: [
    new HtmlwebpackPlugin({
      title: 'React Biolerplate by Linghucong',
      template: path.resolve(__dirname, 'templates/index.ejs'),
      inject: 'body'
    })
  ]
```

关于 html-webpack-plugin 更多高级用法可以[参考其项目主页](https://github.com/ampedandwired/html-webpack-plugin)。

### 更新项目代码

对我们的组件稍作修改：
```
import './index.less';

import component from './component';

let content = document.getElementById("content");
content.appendChild(component());
```

然后编译，运行：
```
$ npm run build
$ npm run dev
```

可以看到，目前访问 http://localhost:3000/ 的页面显示已经发生了变化。
![]()

通过查看源代码，可以看到我们页面正是应用了我们的模板文件。

![]()

到目前为止的代码可以在[react_boilerplate _v3]()中查看。

## 创建React组件

我们将`app/index.js`修改一下，创建一个新的React组件。

##### app/index.js
```
import React from 'react';
import ReactDOM from 'react-dom';
 
class HelloReact extends React.Component {
  render() {
    return <h1>Hello React!</h1>
  }
}
 
ReactDOM.render(<HelloReact/>, document.getElementById('content'));
```

代码十分简单，引入了`react`和`react-dom`，创建了一个叫做HelloReact的组件，并将其渲染到页面上id为`content`的DOM元素内。

## 编译React代码

我们在之前已经在webpack的配置中配置好了对React的支持，因此目前不需要做什么修改了。

`npm run build`之后就可以在页面上看到“Hello React!”了。

至此，我们基于ES6并使用webpack和Babel的React初始项目已经可以完美运行了。
到目前为止的代码可以在[react_boilerplate _v4]()中查看。

# 测试环境搭建（Mocha + Chai + Sinon + Enzyme）

## 所用技术介绍

如上所见，我在这里使用Mocha + Chai + Sinon + Enzyme这几个技术来搭建我们的测试环境，简单介绍如下：

 - Mocha：用于运行我们的测试用例。  
 - Chai：Mocha用的断言库。 
 - Sinon：用于创建一些mocks/stubs/spys。
 - Enzyme：React代码测试专用，由AirBnB创建。

## Mocha安装及环境配置

### 安装Mocha、Chai以及Sinon

安装很简单，命令如下：
```
npm i mocha chai sinon --save-dev
```

因为我们要支持ES6的语法，因此还需要安装一个额外的插件`babel-register`：

```
npm i babel-register --save-dev
```

### 写一个简单的测试用例

Mocha默认会去当前目录下找test目录，然后在其中去找后缀为.js的文件。如果需要修改这个目录，可以使用Mocha的参数进行设置。
我们这里创建一个新的目录，叫做test，然后一个新的Spec文件：

##### index.spec.js
```
import { expect } from 'chai';

describe('hello react spec', () => {
  it('works!', () => {
    expect(true).to.be.true;
  });
});
```

这个时候我们在命令行中使用命令`mocha --compilers js:babel-register`运行mocha，如果顺利的话，可以看到如下结果：

```
$ mocha --compilers js:babel-register
  hello react spec
    √ works!
    
  1 passing (11ms)
```

简单解释一下这里的`babel-register`。如果这里没有添加`--compilers`选项，则mocha会按照默认的方式执行，也就是“读取spec文件”->“运行测试用例”。使用了`babel-register`之后，则执行顺序为“读取spec文件”->“将ES6代码编译为ES5代码”->“运行测试用例”。

#### 踩坑提醒

如果执行`mocha --compilers js:babel-register`命令的时候，出现如下的错误：
```
$ mocha --compilers js:babel-register
D:\node\react_boilerplate\test\index.spec.js:1
(function (exports, require, module, __filename, __dirname) { import { expect } from 'chai';
                                                              ^^^^^^
SyntaxError: Unexpected reserved word
    at exports.runInThisContext (vm.js:53:16)
    at Module._compile (module.js:373:25)
    at loader (D:\node\react_boilerplate\node_modules\babel-register\lib\node.js:126:5)
    at Object.require.extensions.(anonymous function) [as .js] (D:\node\react_boilerplate\node_modules\babel-register\lib\node.js:136:7)
    at Module.load (module.js:343:32)
    at Function.Module._load (module.js:300:12)
    at Module.require (module.js:353:17)
    at require (internal/module.js:12:17)
    at C:\Users\i301792\AppData\Roaming\npm\node_modules\mocha\lib\mocha.js:219:27
    at Array.forEach (native)
    at Mocha.loadFiles (C:\Users\i301792\AppData\Roaming\npm\node_modules\mocha\lib\mocha.js:216:14)
    at Mocha.run (C:\Users\i301792\AppData\Roaming\npm\node_modules\mocha\lib\mocha.js:468:10)
    at Object.<anonymous> (C:\Users\i301792\AppData\Roaming\npm\node_modules\mocha\bin\_mocha:403:18)
    at Module._compile (module.js:409:26)
    at Object.Module._extensions..js (module.js:416:10)
    at Module.load (module.js:343:32)
    at Function.Module._load (module.js:300:12)
    at Function.Module.runMain (module.js:441:10)
    at startup (node.js:139:18)
    at node.js:968:3
```
这个错误可能是由于Babel的版本引入的。[在这里](https://github.com/mochajs/mocha/issues/2054)提供了一个解决方案：

在我们项目中创建一个.babelrc文件，其内容如下：
```
{
  "presets": ["react", "es2015"]
}
```
其作用之前讲过了。现在就可以将我们`webpack.config.js`中对应设置删除了：
```
#webpack.config.js
...
      { 
        test: /\.jsx?$/, 
        loader: 'babel', 
        exclude: /node_modules/
      },  
```

### 创建测试工具库test_helper.js

注意到我们在每个测试spec文件中，都会需要引入chai库的expect，这样就会有很多重复代码。当然还有其他一些通用的帮助性代码，因此我们需要一个库来集中进行管理。这里我们创建一个新的文件`/test/test_helper.js`:

##### /test/test_helper.js
```
import { expect } from 'chai';
import sinon from 'sinon';

global.expect = expect;
global.sinon = sinon;
```
在这里我只是添加了chai的expect，以及引入了sinon。

现在就可以将`index.spec.js`文件的第一行删除，然后通过如下的命令来执行mocha命令了：
```
mocha --compilers js:babel-register --require ./test/test_helper.js --recursive
```

执行结果如下：

```
λ mocha --compilers js:babel-register --require ./test/test_helper.js --recursive
  hello react spec
    √ works!
  1 passing (12ms)
```

### 配置`package.json`中的快捷方式

在`package.json`中我们可以创建上述mocha命令的快捷方式。在`scripts`字段中作如下修改：

```
#package.json

  "scripts": {
    "test": "mocha --compilers js:babel-register --require ./test/test_helper.js --recursive ./test",
    "test:watch": "npm test -- --watch",
    "dev": "webpack-dev-server --port 3000 --devtool eval --progress --colors --hot --content-base dist",
    "build": "webpack"
  },
```

然后就可以使用
```
npm run test
```
来直接运行mocha了。

注意这里我还新增加了一个`npm run test:watch`快捷方式，其实就是使用了mocha的`--watch`选项。有了它，当我们在对代码进行修改的时候，就会自动运行test了。

## Enzyme的安装和使用





# 参考链接
http://blog.david-reid.com/2016/02/07/webpack-dev-server/
[深入浅出React](http://www.infoq.com/cn/dive-into-react)
[Webpack傻瓜式指南](http://zhuanlan.zhihu.com/p/20367175)
[Setting up React for ES6 with Webpack and Babel](https://www.twilio.com/blog/2015/08/setting-up-react-for-es6-with-webpack-and-babel-2.html)
[Mocha + Chai.js unit testing for ES6 with Istanbul code coverage](https://onsen.io/blog/mocha-chaijs-unit-test-coverage-es6/)
[davezuko/react-redux-starter-kit](https://github.com/davezuko/react-redux-starter-kit)
