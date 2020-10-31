class Gp2y0a21yk0f
  def self.volt_to_distance(volt)
    return 0 if volt == 0

    dist = (6787 / (volt - 3)) - 4
    dist.round(4)
  end
end
