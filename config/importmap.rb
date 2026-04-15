# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@floating-ui/dom", to: "@floating-ui--dom.js" # @1.7.6
pin "@floating-ui/core", to: "@floating-ui--core.js" # @1.7.5
pin "@floating-ui/utils", to: "@floating-ui--utils.js" # @0.2.11
pin "@floating-ui/utils/dom", to: "@floating-ui--utils--dom.js" # @0.2.11
pin "motion" # @12.38.0
pin "framer-motion/dom", to: "framer-motion--dom.js" # @12.38.0
pin "motion-dom" # @12.38.0
pin "motion-utils" # @12.36.0
pin "mustache" # @4.2.0
pin "embla-carousel" # @8.6.0
pin "fuse.js" # @7.3.0
pin "tippy.js" # @6.3.7
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "maska" # @3.2.0
