module.exports = {
    "extends": [
        "eslint:recommended",
        "react-app",
        "plugin:react/jsx-runtime",
        "prettier"
    ],
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "project": [
            "./tsconfig.json",
            "./tsconfig.node.json"
        ],
        "tsconfigRootDir": __dirname
    },
    "plugins": [
        "@typescript-eslint",
        "unused-imports"
    ],
    "root": true,
    "ignorePatterns": [
        "dist",
        ".eslintrc.cjs"
    ],
    "rules": {
        "unused-imports/no-unused-imports": "error",
        "unused-imports/no-unused-vars": [
            "warn",
            {
                "vars": "all",
                "varsIgnorePattern": "^_",
                "args": "after-used",
                "argsIgnorePattern": "^_"
            }
        ],
        "@typescript-eslint/consistent-type-imports": [
            2,
            {
                "fixStyle": "separate-type-imports"
            }
        ]
    },
    "overrides": [
        {
            "files": [
                "*.{c,m,}{t,j}s",
                "*.{t,j}sx"
            ]
        },
        {
            "files": [
                "*{test,spec}.{t,j}s?(x)"
            ],
            "env": {
                "jest": true
            }
        }
    ]
}
