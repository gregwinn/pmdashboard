import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        if ($(".alert").is(":visible")) {
            setTimeout(function() {
                $(".alert").slideUp('slow');
            }, 5000);
        }
    }
}