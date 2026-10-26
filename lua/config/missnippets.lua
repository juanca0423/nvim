local M = {}

function M.setup()
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local f = ls.function_node

  -- Cargar snippets predefinidos de friendly-snippets
  pcall(function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end)

  -- Función auxiliar segura para convertir a minúsculas
  local function safe_lower(args)
    local text = (args[1] and args[1][1]) or ""
    return string.lower(text)
  end

  -- Función auxiliar segura para snake_case
  local function snake_case(args)
    local text = (args[1] and args[1][1]) or ""
    text = string.lower(text)
    return (string.gsub(text, "%s+", "_"))
  end

  -- ==========================================
  -- SNIPPETS PARA HANDLEBARS
  -- ==========================================
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
      f(safe_lower, { 3 }),
      t({ '" placeholder="Ingrese ' }),
      i(4, "datos"),
      t({ '">', "</div>" }),
    }),

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

    s("eac", {
      t("{{#each "),
      i(1, "array"),
      t("}}"),
      t({ "", "  " }),
      i(2, ""),
      t({ "", "{{/each}}" }),
    }),

    s("if", {
      t("{{#if "),
      i(1, "condicion"),
      t("}}"),
      t({ "", "  " }),
      i(2),
      t({ "", "{{/if}}" }),
    }),

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

  -- ==========================================
  -- SNIPPETS PARA GO (Con Fiber y GORM)
  -- ==========================================
  ls.add_snippets("go", {
    s("fibapp", {
      t({ "app := fiber.New()", "", 'app.Get("/", func(c *fiber.Ctx) error {', '  return c.SendString("' }),
      i(1, "¡Hola Fiber!"),
      t({ '")', "})" }),
      i(0),
    }),

    s("fibhandler", {
      t("func "),
      i(1, "NombreHandler"),
      t("(c *fiber.Ctx) error {"),
      t({ "", "  " }),
      i(0),
      t({ "", "  return c.Status(fiber.StatusOK).JSON(fiber.Map{", '    "message": "' }),
      i(2, "ok"),
      t({ '"', "  })" }),
      t({ "", "}" }),
    }),

    s("gormmod", {
      t("type "),
      i(1, "NombreModelo"),
      t(" struct {"),
      t({ "", "  gorm.Model" }),
      t({ "", "  " }),
      i(2, "Campo"),
      t(" "),
      i(3, "string"),
      t(' `json:"'),
      f(safe_lower, { 2 }),
      t('" gorm:"type:varchar(100);not null"`'),
      t({ "", "}" }),
      i(0),
    }),

    s("gormcon", {
      t({ 'dsn := "host=localhost user=postgres password=secret dbname=' }),
      i(1, "midb"),
      t({
        ' port=5432 sslmode=disable"',
        "db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})",
        "if err != nil {",
      }),
      t({ "", '  log.Fatalf("Error al conectar BD: %v", err)' }),
      t({ "", "}" }),
      i(0),
    }),

    s("fibbody", {
      t("req := new("),
      i(1, "StructNombre"),
      t(")"),
      t({ "", "if err := c.BodyParser(req); err != nil {" }),
      t({ "", '  return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})' }),
      t({ "", "}" }),
      i(0),
    }),

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
      f(safe_lower, { 1 }),
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
      f(safe_lower, { 1 }),
      t('" form:"'),
      f(safe_lower, { 1 }),
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
      f(safe_lower, { 2 }),
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

    s("ctx", {
      t("ctx, cancel := context.WithTimeout(context.Background(), "),
      i(1, "5"),
      t("*time.Second)"),
      t({ "", "defer cancel()" }),
      i(0),
    }),
  })

  -- ==========================================
  -- SNIPPETS PARA JAVASCRIPT
  -- ==========================================
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

  -- ==========================================
  -- SNIPPETS PARA SQL
  -- ==========================================
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
      t(")"), -- <-- Corregido aquí
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
      i(2, "ColumnName"),
      t(") VALUES (?)`"),
      t({ "", "_, err := db.Exec(query, " }),
      f(snake_case, { 2 }),
      t(")"),
      i(0),
    }),
  })

  -- ==========================================
  -- EXTENSIONES DE FILETYPE
  -- ==========================================
  ls.filetype_extend("handlebars", { "html" })
  ls.filetype_extend("go", { "sql" })
  ls.filetype_extend("javascriptreact", { "html" })
end

return M
