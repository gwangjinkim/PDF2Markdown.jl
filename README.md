# PDF2Markdown.jl

Convert scanned and regular PDFs into structured Markdown using **local LLMs** (via [Ollama](https://ollama.com)) — 100% Julia, no cloud, no APIs, no nonsense.

> OCR, layout parsing, and Markdown generation in one clean Julia pipeline.

---

## Features

- Converts each page of a PDF to high-resolution PNG images using `Poppler_jll`
- Sends images to a **local Ollama** instance (e.g., `gemma3:12b`)
- 100% local — **no internet required**, your data stays on your machine
- Outputs structured, clean Markdown

---

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/your-username/PDF2Markdown.jl")
```

Or clone the repo manually and `Pkg.develop`.

---

## Usage

```julia
using PDF2Markdown

text = extract_text_from_pdf("path/to/your.pdf")
println(text)
```

> You must have `ollama` installed and running locally, with a model like `gemma3:12b` pulled.

---

## Requirements

- Julia ≥ 1.9
- [`Ollama`](https://ollama.com/download) running locally
- A pulled model like `gemma3:12b` or `gemma3:4b`
- Poppler must be functional via `Poppler_jll`

---

## Example

```julia
text = extract_text_from_pdf("document.pdf")
write("output.md", text)
```

---

## Notes

- Internally uses:
  - `Poppler_jll` to convert PDF pages to images
  - `Base64` to encode images for Ollama
  - `HTTP.jl` and `JSON3.jl` to communicate with the LLM
- If you're converting large PDFs, consider batching pages.

---

## Related Project

🔗 Python version: [`pdf2md-ollama`](https://github.com/yourusername/pdf2md-ollama)

---

## Credits

Inspired by [this article on Medium](https://medium.com/data-science-collective/convert-pdfs-to-markdown-using-local-llms-c5232f3b50fc?sk=9b0036a7ff93a1c48bae7dd8216dc671)

---

## License

MIT


