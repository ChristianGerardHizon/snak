/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_vw_pos_search");

  return app.delete(collection);
}, (app) => {
  const collection = new Collection({
    "createRule": null,
    "deleteRule": null,
    "fields": [
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text3208210256",
        "max": 0,
        "min": 0,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "_clone_LDgl",
        "max": 0,
        "min": 0,
        "name": "name",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "_clone_VcM9",
        "max": null,
        "min": 0,
        "name": "price",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "json2363381545",
        "maxSize": 1,
        "name": "type",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_HCBw",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "branch",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      }
    ],
    "id": "pbc_vw_pos_search",
    "indexes": [],
    "listRule": "",
    "name": "vw_pos_search_items",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT id, name, price, 'product' AS type, branch FROM products WHERE isDeleted = FALSE AND forSale = TRUE UNION ALL SELECT id, name, price, 'service' AS type, branch FROM services WHERE isDeleted = FALSE",
    "viewRule": ""
  });

  return app.save(collection);
})
