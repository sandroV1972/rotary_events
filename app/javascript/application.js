// Import Rails UJS to handle the delete method for links (e.g., logout)
import Rails from "@rails/ujs";
Rails.start();

// Import Turbo for navigation
import "@hotwired/turbo-rails";

// Import Stimulus controllers if you have them
import "controllers";