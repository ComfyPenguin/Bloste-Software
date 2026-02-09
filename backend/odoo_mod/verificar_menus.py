import sys
sys.path.append('/usr/lib/python3/dist-packages')
import odoo
from odoo import api

# Configura Odoo amb el fitxer de configuracio i la base de dades
odoo.tools.config.parse_config(['-c', '/etc/odoo/odoo.conf', '-d', 'bloste'])

try:
    with odoo.api.Environment.manage():
        registry = odoo.registry('bloste')
        with registry.cursor() as cr:
            env = api.Environment(cr, odoo.SUPERUSER_ID, {})
            
            # Busca el lloc web de Bloste a la BD
            website = env['website'].search([('name', '=', 'Bloste')], limit=1)
            if not website:
                website = env['website'].search([], limit=1)
            
            print(f"Lloc web trobat: {website.name} (ID: {website.id})")
            
            # Busca el menu principal (el que no te pare)
            main_menu = env['website.menu'].search([
                ('parent_id', '=', False),
                ('website_id', '=', website.id)
            ], limit=1)
            
            print(f"Menu principal: {main_menu.name} (ID: {main_menu.id})")
            
            # Llista tots els menus que hi ha ara
            all_menus = env['website.menu'].search([('website_id', '=', website.id)])
            print(f"\nMenus actuals ({len(all_menus)}):")
            for menu in all_menus:
                print(f"  - {menu.name} ({menu.url}) - Sequence: {menu.sequence}")
            
            # Definix els menus que volem crear
            menus_to_create = [
                {'name': 'Inicio', 'url': '/', 'sequence': 10},
                {'name': 'Planes', 'url': '/suscripciones', 'sequence': 20},
                {'name': 'Registrarse', 'url': '/in', 'sequence': 30},
            ]
            
            # Comprova si els menus existixen i si no, els crea
            for menu_data in menus_to_create:
                existing = env['website.menu'].search([
                    ('name', '=', menu_data['name']),
                    ('website_id', '=', website.id),
                    ('url', '=', menu_data['url'])
                ])
                
                if not existing:
                    print(f"\nCreant menu: {menu_data['name']}")
                    env['website.menu'].create({
                        'name': menu_data['name'],
                        'url': menu_data['url'],
                        'parent_id': main_menu.id,
                        'sequence': menu_data['sequence'],
                        'website_id': website.id
                    })
                else:
                    print(f"\nEl menu ja existix: {menu_data['name']}")
            
            # Guarda els canvis a la BD
            cr.commit()
            print("\nProces completat")
            
except Exception as e:
    print(f"ERROR: {e}")
    import traceback
    traceback.print_exc()
