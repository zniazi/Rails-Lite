require_relative '../phase6/controller_base'

module Bonus
  class ControllerBase < Phase6::ControllerBase

    def render_content(content, type)
      super
      self.flash.flash_hash.each_key do { |key| self.flash.flash_hash[key][1] += 1}
      self.flash.store_flash(self.res)
    end

    def redirect_to(url)
      super
      self.flash.flash_hash.each_key do { |key| self.flash.flash_hash[key][1] += 1}
      self.flash.store_flash(self.res)
    end

    def flash
      @flash ||= Flash.new(self.req)
    end
  end
end