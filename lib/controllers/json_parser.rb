class JsonParser
    def parse(body)
        if body.nil? || body.empty?
            return nil
        end
        
        root = body["meme"]
        Meme.new(root["image_url"], root["text"])
    end
end