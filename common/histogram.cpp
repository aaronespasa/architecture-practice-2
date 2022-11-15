#include "histogram.hpp"
#include <fstream>

namespace images::common {
  void histogram::add_color(pixel p) noexcept {
    #pragma omp critical 
    channels[red_channel][p.red()]++;
    #pragma omp critical
    channels[green_channel][p.green()]++;
    #pragma omp critical
    channels[blue_channel][p.blue()]++;
  }

  void histogram::write(std::ostream & os) const noexcept {
    for (const auto x: channels[red_channel]) {
      os << x << '\n';
    }
    for (const auto x: channels[green_channel]) {
      os << x << '\n';
    }
    for (const auto x: channels[blue_channel]) {
      os << x << '\n';
    }
  }

  void histogram::add_red(uint8_t r) noexcept {
    #pragma omp critical
    channels[red_channel][r]++;
  }

  void histogram::add_green(uint8_t g) noexcept {
    #pragma omp critical
    channels[green_channel][g]++;
  }

  void histogram::add_blue(uint8_t b) noexcept {
    #pragma omp critical
    channels[blue_channel][b]++;
  }
}
