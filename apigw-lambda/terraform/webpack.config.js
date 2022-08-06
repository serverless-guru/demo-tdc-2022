/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-require-imports */
'use strict';

const { DefinePlugin } = require('webpack');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const TsconfigPathsPlugin = require('tsconfig-paths-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

const path = require('path');

module.exports = () => {
  return {
    optimization: {
      minimize: true,
      mangleExports: false,
      minimizer: [
        new TerserPlugin({
          extractComments: false,
          include: /vendor/,
        }),
      ],
      splitChunks: {
        cacheGroups: {
          vendor: {
            test: /node_modules/,
            chunks: 'initial',
            name: 'vendor',
            priority: 10,
            enforce: true,
          },
        },
      },
    },
    externalsPresets: { node: true },
    externals: {
      'aws-sdk': 'aws-sdk',
      fsevents: "require('fsevents')",
    },
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
      'hello-world': path.join(__dirname, './src/lambdas/hello-world.ts'),
    },
    output: {
      filename: '[name].js',
      path: path.join(__dirname, './dist'),
      libraryTarget: 'commonjs2',
    },
    mode: 'production',
    plugins: [new CleanWebpackPlugin(), new DefinePlugin({})],
  };
};
