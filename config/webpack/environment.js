const { environment } = require('@rails/webpacker')
// JQuery, Poper(Bootstrap4の前提)
const webpack = require('webpack')
environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: 'popper.js'
    })
)


// ESlint(Vueあり)の設定
const eslint =  require('./loaders/eslint')

environment.loaders.append('eslint', eslint)

// エクスポート
module.exports = environment
