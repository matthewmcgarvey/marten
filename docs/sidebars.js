module.exports = {
  sidebar: [
    'prologue',
    {
      type: 'category',
      label: 'Getting Started',
      link: {type: 'doc', id: 'getting-started'},
      items: [
        'getting-started/installation',
        'getting-started/tutorial',
      ],
    },
    {
      type: 'category',
      label: 'Models and databases',
      link: {type: 'doc', id: 'models-and-databases'},
      items: [
        'models-and-databases/introduction',
        'models-and-databases/queries',
        'models-and-databases/validations',
        'models-and-databases/callbacks',
        'models-and-databases/migrations',
        'models-and-databases/transactions',
        'models-and-databases/raw-sql',
        {
          type: 'category',
          label: "How-To's",
          items: [
            'models-and-databases/how-to/create-custom-model-fields',
          ],
        },
        {
          type: 'category',
          label: 'Reference',
          items: [
            'models-and-databases/reference/fields',
            'models-and-databases/reference/query-set',
            'models-and-databases/reference/migration-operations',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Handlers and HTTP',
      link: {type: 'doc', id: 'handlers-and-http'},
      items: [
        'handlers-and-http/introduction',
        'handlers-and-http/routing',
        'handlers-and-http/generic-handlers',
        'handlers-and-http/error-handlers',
        'handlers-and-http/middlewares',
        'handlers-and-http/sessions',
        {
          type: 'category',
          label: "How-To's",
          items: [
            'handlers-and-http/how-to/create-custom-route-parameters',
          ],
        },
        {
          type: 'category',
          label: 'Reference',
          items: [
            'handlers-and-http/reference/generic-handlers',
            'handlers-and-http/reference/middlewares',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Templates',
      link: {type: 'doc', id: 'templates'},
      items: [
        'templates/introduction',
        {
          type: 'category',
          label: "How-To's",
          items: [
            'templates/how-to/create-custom-filters',
            'templates/how-to/create-custom-tags',
            'templates/how-to/create-custom-context-producers',
          ],
        },
        {
          type: 'category',
          label: 'Reference',
          items: [
            'templates/reference/filters',
            'templates/reference/tags',
            'templates/reference/context-producers',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Schemas',
      link: {type: 'doc', id: 'schemas'},
      items: [
        'schemas/introduction',
        'schemas/validations',
        {
          type: 'category',
          label: "How-To's",
          items: [
            'schemas/how-to/create-custom-schema-fields',
          ],
        },
        {
          type: 'category',
          label: 'Reference',
          items: [
            'schemas/reference/fields',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Files',
      link: {type: 'doc', id: 'files'},
      items: [
        'files/uploading-files',
        'files/managing-files',
        'files/asset-handling',
      ],
    },
    {
      type: 'category',
      label: 'Development',
      link: {type: 'doc', id: 'development'},
      items: [
        'development/settings',
        'development/applications',
        'development/management-commands',
        'development/testing',
        {
          type: 'category',
          label: "How-To's",
          items: [
            'development/how-to/create-custom-commands',
          ],
        },
        {
          type: 'category',
          label: 'Reference',
          items: [
            'development/reference/settings',
            'development/reference/management-commands',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Security',
      link: {type: 'doc', id: 'security'},
      items: [
        'security/introduction',
        'security/csrf',
        'security/clickjacking',
      ],
    },
    {
      type: 'category',
      label: 'Internationalization',
      link: {type: 'doc', id: 'i18n'},
      items: [
        'i18n/introduction',
      ],
    },
    {
      type: 'category',
      label: 'Deployment',
      link: {type: 'doc', id: 'deployment'},
      items: [
        'deployment/introduction',
      ],
    },
    {
      type: 'category',
      label: 'The Marten project',
      link: {type: 'doc', id: 'the-marten-project'},
      items: [
        'the-marten-project/contributing',
        'the-marten-project/acknowledgements',
        {
          type: 'category',
          label: 'Release notes',
          link: {type: 'doc', id: 'the-marten-project/release-notes'},
          collapsible: false,
          className: 'release-notes',
          items: [
            'the-marten-project/release-notes/0.1',
            'the-marten-project/release-notes/0.1.1',
            'the-marten-project/release-notes/0.1.2',
            'the-marten-project/release-notes/0.1.3',
            'the-marten-project/release-notes/0.2',
          ],
        },
      ],
    },
  ],
};
