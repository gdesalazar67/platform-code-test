
class Award
    attr_reader :max_quality, :min_quality
    attr_accessor :name, :expires_in, :quality
    def initialize(name, expires_in, quality)
        @name = name
        @expires_in = expires_in
        @max_quality = 50
        @min_quality = 0
        @quality = self.keep_in_range(quality)
    end

    def keep_in_range(quality)
        case 
            when quality < min_quality then return 0
            when quality > max_quality then return 50
            else quality
        end
    end

    def self.all 
        ObjectSpace.each_object(self).to_a
    end 

    def greater_then_min_quality?
        return self.quality > min_quality ? true: false
    end

    def expired?
       return self.expires_in < 0 ? true: false 
    end

    def update_quality
        self.quality -=1 if self.greater_then_min_quality?
        self.expires_in -=1 
        self.quality -= 1 if self.expired? &&  self.greater_then_min_quality?
    end

    def self.update_quality_all_awards
        Award.all.each do |award|
            award.update_quality
        end
    end
end


class BlueFirst < Award 

    def update_quality
        self.quality +=1 if self.quality < max_quality
        self.expires_in -=1 

        self.quality += 1 if self.expired? && self.quality < max_quality
    end

end 

class BlueCompare < Award

    def update_quality
        if self.quality < max_quality
            self.quality +=1
            self.quality += 1 if self.expires_in < 11
            self.quality += 1 if self.expires_in < 6  
        end

        self.expires_in -=1 

        self.quality = 0 if self.expired?
    end

end

class BlueDistinctionPlus < Award 

    @@value = 80

    def initialize(name, expires_in, quality)
        super(name, expires_in, @@value)
    end

    def update_quality
        self.quality = @@value
    end
end 

class BlueStar < Award
    def update_quality
        self.quality -=2 if self.greater_then_min_quality?
        self.expires_in -=1 
        self.quality -= 2 if self.expired? &&  self.greater_then_min_quality?
        self.quality = min_quality if self.quality < min_quality
    end
end
