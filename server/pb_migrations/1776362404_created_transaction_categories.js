/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = new Collection({
    "createRule": null,
    "deleteRule": null,
    "fields": [
      {
        "autogeneratePattern": "[a-z0-9]{15}",
        "hidden": false,
        "id": "text3208210256",
        "max": 15,
        "min": 15,
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
        "id": "text1579384326",
        "max": 0,
        "min": 0,
        "name": "name",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": true,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "select1002749145",
        "maxSelect": 1,
        "name": "kind",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "select",
        "values": [
          "expense",
          "income",
          "transfer"
        ]
      },
      {
        "hidden": false,
        "id": "select2419107044",
        "maxSelect": 1,
        "name": "iconSource",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "select",
        "values": [
          "system",
          "custom"
        ]
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text2149973835",
        "max": 0,
        "min": 0,
        "name": "iconKey",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text1712867039",
        "max": 0,
        "min": 0,
        "name": "iconColor",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "number1063427325",
        "max": null,
        "min": null,
        "name": "sortOrder",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "bool4206062621",
        "name": "isArchived",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "bool"
      }
    ],
    "id": "pbc_1091709928",
    "indexes": [],
    "listRule": null,
    "name": "transaction_categories",
    "system": false,
    "type": "base",
    "updateRule": null,
    "viewRule": null
  });

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1091709928");

  return app.delete(collection);
})
