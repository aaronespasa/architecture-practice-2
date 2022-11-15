#ifndef IMAGES_COMMON_HISTOGRAM_HPP
#define IMAGES_COMMON_HISTOGRAM_HPP

#include "common/pixel.hpp"

#include <vector>
#include <omp.h>
#include <cstdint>
#include <filesystem>

namespace images::common {

  class histogram {
  public:
    histogram() noexcept = default;

    void add_color(pixel p) noexcept;

    void add_red(uint8_t r) noexcept;

    void add_green(uint8_t g) noexcept;

    void add_blue(uint8_t b) noexcept;

    [[nodiscard]] int get_red_frequency(uint8_t v) const noexcept {
      return channels[red_channel][v];
    }

    [[nodiscard]] int get_green_frequency(uint8_t v) const noexcept {
      return channels[green_channel][v];
    }

    [[nodiscard]] int get_blue_frequency(uint8_t v) const noexcept {
      return channels[blue_channel][v];
    }

    void write(std::ostream & os) const noexcept;

  private:
    static constexpr int num_levels = 256;
    std::array<std::vector<int>, 3> channels = {std::vector<int>(num_levels),
                                                std::vector<int>(num_levels),
                                                std::vector<int>(num_levels),};
  };

} // common

#endif //IMAGES_COMMON_HISTOGRAM_HPP
