import { Controller } from "@hotwired/stimulus"
import moment from 'moment'

export default class extends Controller {
    static targets = ["project_form"]
    static values = { duedate: String }
    connect() {
        $('#project_due_date, #work_task_due_date').datepicker({
            minDate: 0,
            dateFormat: 'yy-mm-dd',
            startDate: moment(new Date(this.duedateValue)).format('YYYY-MM-DD') || moment().format('YYYY-MM-DD'),
            autoclose: true
        });
    }
}