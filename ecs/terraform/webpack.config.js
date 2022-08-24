/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-require-imports */
'use strict';

const { DefinePlugin } = require('webpack');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const TsconfigPathsPlugin = require('tsconfig-paths-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const nodeExternals = require('webpack-node-externals');
const NodemonPlugin = require('nodemon-webpack-plugin');

const path = require('path');

// See more - https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/nodemon/index.d.ts
const nodemon = new NodemonPlugin({
  /*
   * If using more than one entry, you can specify
   * which output file will be restarted.
   */
  // script: './dist/server.js',

  // What to watch.
  watch: path.join(__dirname, './dist'),

  // Arguments to pass to the script being watched.

  // args: ['demo'],

  // Node arguments.

  // nodeArgs: ['--debug=9222'],

  // Files to ignore.

  // ignore: ['*.js.map'],

  // Extensions to watch.
  ext: 'js,json',

  /*
   * Unlike the cli option, delay here is in milliseconds (also note that it's a string).
   * Here's 1 second delay:
   */
  delay: '1000',
  signal: 'SIGINT',

  // Detailed log.
  verbose: false,

  // Environment variables to pass to the script to be restarted
  env: {
    NODE_ENV: 'dev',
  },
});

module.exports = (env) => {
  const watch = env.watch === 'y';

  return {
    optimization: {
      minimize: false,
      mangleExports: false,
      minimizer: [
        new TerserPlugin({
          extractComments: false,
          exclude: '/api/',
        }),
      ],
    },
    externals: [nodeExternals()],
    externalsPresets: { node: true },
    target: 'node',
    devtool: false,
    resolve: {
      extensions: ['.ts', '.js'],
      plugins: [new TsconfigPathsPlugin()],
    },
    stats: {
      warnings: false,
      modules: false,
    },
    module: {
      rules: [
        {
          test: /\.ts$/,
          use: 'ts-loader',
          exclude: /node_modules/,
        },
      ],
    },
    entry: {
      api: path.join(__dirname, './bin/api.ts'),
    },
    output: {
      filename: '[name].js',
      path: path.join(__dirname, './dist'),
    },
    mode: 'production',
    plugins: [
      ...(watch ? [nodemon] : []),
      new CleanWebpackPlugin(),
      new DefinePlugin({
        GLOBAL_VAR_IS_LOCAL: JSON.stringify(watch),
        GLOBAL_VAR_SERVICE_NAME: JSON.stringify('ecs-tf'),
        GLOBAL_VAR_NODE_ENV: JSON.stringify(process.env.NODE_ENV),
        GLOBAL_VAR_REGION: JSON.stringify('us-east-2'),
      }),
    ],
  };
};
