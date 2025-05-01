using Poppler_jll, FileIO, ImageIO, Base64, HTTP, JSON3

function pdf_to_png_in_memory(pdf_path::String; dpi=300)
    temp_dir = mktempdir()  # Temporary directory for images
    output_prefix = joinpath(temp_dir, "page")  # Naming pattern for images

    # Convert PDF to PNG images using Poppler's pdftoppm
    run(`$(Poppler_jll.pdftoppm()) -png -r $dpi $pdf_path $output_prefix`)

    # Collect PNG images from temp directory
    images = []
    for img_file in sort(readdir(temp_dir))  # Ensure correct order
        if endswith(img_file, ".png")
            img_path = joinpath(temp_dir, img_file)
            push!(images, read(img_path))  # Read as raw bytes
        end
    end

    return images
end

function pdf_to_base64_images(pdf_path::String; dpi=300)
    png_images = pdf_to_png_in_memory(pdf_path, dpi=dpi)
    return [base64encode(img) for img in png_images]  # Convert each image to Base64
end

function extract_text_from_images(base64_images::Vector{String})
    url = "http://localhost:11434/api/chat"

    # Construct JSON request (Ollama requires Base64 format)
    request_body = JSON3.write(Dict(
        "model" => "gemma3:12b",
        "stream" => false,  # Ensures full response instead of chunks
        "messages" => [Dict(
            "role" => "user",
            "content" => "Extract all readable text and text chunks from this image and format it as structured Markdown. Look in the entire image always and try to retrieve all text!",
            "images" => base64_images  # Use Base64
        )]
    ))

    headers = ["Content-Type" => "application/json"]

    try
        response = HTTP.post(url, headers, request_body)
        
        # Convert response body to string
        response_body = String(response.body)

        # Parse JSON manually (handling multiple responses)
        parsed_responses = JSON3.read.([split(response_body, "\n")...])

        # Extract and combine all message content into one Markdown output
        extracted_text = join([r[:message][:content] for r in parsed_responses if :message in keys(r)], "")

        return extracted_text
    catch e
        println("Error querying Ollama: ", e)
        return "Error"
    end
end

# text = extract_text_from_images(base64_images)
# println("🔍 Extracted Text:\n", text) # this works!!

function extract_text_from_pdf(pdf_path::String; dpi=300)
    base64_images = pdf_to_base64_images(pdf_path)
    return extract_text_from_images(base64_images)
end

