class JsonParserService
    def parse(body)
        if body.nil? || body.empty?
            return nil
        end
        
        root = body["meme"]
        if root.nil? || root.empty?
            return nil
        end
        Meme.new(root["image_url"], root["text"])
    end
end