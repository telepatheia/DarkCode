function changedValueCron(id, targetId){
var config = {
        cronMinutes: {
            'per_1_minutes' : '*',
            'per_15_minutes' :'*/15',
            'per_30_minutes' :'*/30',
            'per_45_minutes' :'*/45',
            'per_59_minutes' :'*/59'
        },
        cronHours: {
            'per_hour' : '*',
            'per_3_hour' : '*/3',
            'per_6_hour' : '*/6',
            'per_12_hour' : '*/12',
            'per_18_hour' : '*/18',
            'per_23_hour' : '*/23'
        },                               
        cronDays: {
            'per_day' : '*',
            'per_2_day' : '*/2',
            'per_7_day' : '*/7',
            'per_14_day' : '*/14',
            'per_21_day' : '*/21',
            'per_29_day' : '*/29'
        },
        cronMonths: {
            'per_month' : '*',
            'per_3_month' : '*/3',
            'per_6_month' : '*/6',
            'per_12_month' : '*/12'
        },
        cronWeekday: {
            'day_0' : '*',
            'day_1' : '*/1',
            'day_2' : '*/2',
            'day_3' : '*/3',
            'day_4' : '*/4',
            'day_5' : '*/5',
            'day_6' : '*/6'
        }
    }
    var finalValue = config[id][$('#'+id).val()]
    $('#'+targetId).val(finalValue)
}