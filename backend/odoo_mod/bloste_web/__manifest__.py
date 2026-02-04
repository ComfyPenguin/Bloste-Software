{
    'name': 'Bloste Website',
    'version': '1.0',
    'depends': ['base', 'bloste_core', 'website'],
    'author': 'Bloste Software',
    'category': 'Bloste',
    'license': 'LGPL-3',
    'installable': True,
    'application': True,
    'data': [
        'security/ir.model.access.csv',
        'views/menus.xml',
        'views/templates.xml',
        'views/website_pages.xml',
    ],
}
