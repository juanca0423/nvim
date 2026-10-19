-- ~/.config/nvim/lua/plugins/snippets.lua
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    -- 1. Configuración base de LuaSnip
    ls.setup({
      keep_roots = true,
      link_roots = true,
      link_children = true,
    })
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 2. Función de ayuda
    local function snake_case(args)
      local text = args[1][1] or ""
      text = string.lower(text)
      text = string.gsub(text, " ", "_")
      return text
    end

    -- 3. TUS SNIPPETS PERSONALIZADOS
    -- SNIPPETS PARA HANDLEBARS
    ls.add_snippets("handlebars", {
      s("hbs!!", {
        t({ "<!DOCTYPE html>", '<html lang="es">', "<head>", "  <meta charset='UTF-8'>", "  <title>" }),
        i(1, "Documento"),
        t({ "</title>", "</head>", "<body>", "  " }),
        i(0),
        t({ "", "</body>", "</html>" }),
      }),

      s("bs-input", {
        t({ '<div class="mb-3">', '  <label class="form-label">' }),
        i(1, "Nombre del Campo"),
        t({ "</label>", '  <input type="' }),
        i(2, "text"),
        t('" class="form-control" name="'),
        i(3, "nombre"),
        t('" id="'),
        f(function(args)
          return args[1][1]:lower()
        end, { 3 }),
        t({ '" placeholder="Ingrese ' }),
        i(4, "datos"),
        t({ '">', "</div>" }),
      }),
      -- Snippet para {{#if}} ... {{else}} ... {{/if}}
      s("ife", {
        t("{{#if "),
        i(1, "condicion"),
        t("}}"),
        t({ "", "  " }),
        i(2),
        t({ "", "{{else}}", "  " }),
        i(3),
        t({ "", "{{/if}}" }),
      }),

      -- Snippet para {{#each}} ... {{/each}}
      s("eac", {
        t("{{#each "),
        i(1, "array"),
        t("}}"),
        t({ "", "  " }),
        i(2, ""),
        t({ "", "{{/each}}" }),
      }),

      -- Snippet para un {{#if}} simple (sin else)
      s("if", {
        t("{{#if "),
        i(1, "condicion"),
        t("}}"),
        t({ "", "  " }),
        i(2),
        t({ "", "{{/if}}" }),
      }),

      -- Snippet: row -> Fila de tabla contable estándar
      s("row", {
        t("<tr>"),
        t({ "", "  <td>" }),
        i(1, "Descripcion"),
        t("</td>"),
        t({ "", "  <td class='text-end'>{{formatCurrency " }),
        i(2, "valor"),
        t("}}</td>"),
        t({ "", "</tr>" }),
      }),

      s("trdb", {
        t("<tr>"),
        t({ "", "  <td>{{ " }),
        i(1, "id"),
        t(" }}</td>"),
        t({ "", "  <td>{{ " }),
        i(2, "nombre"),
        t(" }}</td>"),
        t({ "", "  <td>" }),
        i(0),
        t("</td>"),
        t({ "", "</tr>" }),
      }),
    })

    -- SNIPPETS PARA GO
    ls.add_snippets("go", {
      s("fdb", {
        i(1, "Nombre"),
        t(" "),
        i(2, "string"),
        t(' `json:"'),
        f(snake_case, { 1 }),
        t('" db:"'),
        f(snake_case, { 1 }),
        t('"`'),
        i(0),
      }),

      s("newsheet", {
        t({ "// --- Nueva Pestaña: " }),
        i(1, "Nombre"),
        t({ "", "" }),
        t('sheet := "'),
        i(2, "NombreHoja"),
        t({ '"', "" }),
        t("f.NewSheet(sheet)"),
        t({ "", 'f.SetCellValue(sheet, "A1", "' }),
        i(3, "Encabezado"),
        t({ '")', "" }),
        t('f.SetCellStyle(sheet, "A1", "A1", headerStyle)'),
        t({ "", "", "rowIdx := 2", "for i, data := range " }),
        i(4, "lista"),
        t({ " {", "" }),
        t('    f.SetCellValue(sheet, "A"+strconv.Itoa(rowIdx), data.Nombre)'),
        t({ "", "    rowIdx++", "}" }),
      }),

      s("iferr", {
        t("if err != nil {"),
        t({ "", "  return " }),
        i(1, "nil, err"),
        t({ "", "}" }),
        i(0),
      }),
      s("field", {
        i(1, "Name"),
        t(" "),
        i(2, "string"),
        t(' `json:"'),
        f(function(args)
          return string.lower(args[1][1])
        end, { 1 }),
        t('"`'),
        i(0),
      }),
      s("meth", {
        t("func ("),
        i(1, "r"),
        t(" *"),
        i(2, "Type"),
        t(") "),
        i(3, "Name"),
        t("("),
        i(4),
        t(") "),
        i(5, "error"),
        t(" {"),
        t({ "", "  " }),
        i(0),
        t({ "", "}" }),
      }),
      s("jt", {
        t('`json:"'),
        i(1, "key_name"),
        t('"`'),
      }),
      s("jsfo", {
        i(1, "Nombre"),
        t(" "),
        i(2, "string"),
        t(' `json:"'),
        f(function(args)
          return args[1][1]:lower()
        end, { 1 }),
        t('" form:"'),
        f(function(args)
          return args[1][1]:lower()
        end, { 1 }),
        t('"`'),
        i(0),
      }),
      s("gomodel", {
        t("type "),
        i(1, "Nombre"),
        t(" struct {"),
        t({ "", '    ID        uint      `gorm:"primaryKey" json:"id"`' }),
        t({ "", "    " }),
        i(2, "Campo"),
        t(" "),
        i(3, "string"),
        t(' `json:"'),
        f(function(args)
          return args[1][1]:lower()
        end, { 2 }), -- Corregido índice a 1 porque solo pasamos {2}
        t('"`'),
        t({ "", "}" }),
      }),
      s("sqtable", {
        t("query := `CREATE TABLE IF NOT EXISTS "),
        i(1, "name"),
        t(" ("),
        t({ "", "    id SERIAL PRIMARY KEY," }),
        t({ "", "    " }),
        i(2, "column_name"),
        t(" "),
        i(3, "type"),
        t({ "", ");`" }),
        i(0),
      }),
      s("fn", {
        t("func "),
        i(1, "Nombre"),
        t("("),
        i(2),
        t(") "),
        i(3, "error"),
        t(" {"),
        t({ "", "    " }),
        i(0),
        t({ "", "}" }),
      }),
      s("squp", {
        t("query := `UPDATE "),
        i(1, "table"),
        t(" SET "),
        i(2, "column"),
        t(" = ? WHERE "),
        i(3, "id"),
        t(" = ?`"),
        t({ "", "result, err := db.Exec(query, " }),
        i(4, "val"),
        t(", "),
        i(5, "id"),
        t(")"),
      }),
      s("gocon", {
        t("func "),
        i(1, "Nombre"),
        t("(c *gin.Context) {"),
        t({ "", "    " }),
        i(0),
        t({ "", "}" }),
      }),
    })

    -- SNIPPETS PARA JAVASCRIPT
    ls.add_snippets("javascript", {
      s("exget", {
        t("router.get('/"),
        i(1, "path"),
        t("', (req, res) => {"),
        t({ "", "  " }),
        i(0),
        t({ "", "});" }),
      }),
      s("clg", {
        t("console.log('--- "),
        i(1, "DEBUG"),
        t(" ---');"),
        t({ "", "console.log(" }),
        i(2),
        t(");"),
      }),
      s("afn", {
        t("("),
        i(1, "args"),
        t(") => {"),
        t({ "", "  " }),
        i(0),
        t({ "", "}" }),
      }),
    })

    -- SNIPPETS PARA SQL (CORREGIDO 'add_snippets')
    ls.add_snippets("sql", {
      s("sqsel", {
        t("query := `SELECT "),
        i(1, "*"),
        t(" FROM "),
        i(2, "table_name"),
        t(" WHERE "),
        i(3, "id"),
        t(" = ?`"),
        t({ "", "rows, err := db.Query(query, " }),
        i(4, "id"),
        t(")"),
        t({ "", "if err != nil {" }),
        t({ "", "  return err" }),
        t({ "", "}" }),
        i(0),
      }),
      s("sqscan", {
        t("for rows.Next() {"),
        t({ "", "  err := rows.Scan(&" }),
        i(1, "dest"),
        t(")"),
        t({ "", "  if err != nil {" }),
        t({ "", "    return err" }),
        t({ "", "  }" }),
        t({ "", "}" }),
        i(0),
      }),
      s("sqins", {
        t("query := `INSERT INTO "),
        i(1, "table_name"),
        t(" ("),
        f(snake_case, { 2 }),
        t(") VALUES (?)`"),
        t({ "", "_, err := db.Exec(query, " }),
        i(2, "Value"),
        t(")"),
        i(0),
      }),
      s("ctx", {
        t("ctx, cancel := context.WithTimeout(context.Background(), "),
        i(1, "5"),
        t("*time.Second)"),
        t({ "", "defer cancel()" }),
        i(0),
      }),
    })

    -- EXTENSIONES DE ARCHIVO
    ls.filetype_extend("handlebars", { "html" })
    ls.filetype_extend("go", { "sql" })
    ls.filetype_extend("javascriptreact", { "html" })
  end,
}
