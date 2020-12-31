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

// エクスポート
module.exports = environment
