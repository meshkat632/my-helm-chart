module.exports = {
    branches: ['main'],
    plugins: [
        '@semantic-release/github',
        [
            'semantic-release-helm',
            {
                npmPublish: false,
                chartPath: 'charts/my-app',
              },
        ]
    ],
};
