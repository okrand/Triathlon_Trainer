/*
See LICENSE.txt for this sample’s licensing information.

Abstract:
View controller for the configuration screen.
*/

import UIKit
import HealthKit
import CoreLocation

class ConfigurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Properties

    private let activityTypes: [WorkoutType] = [.walking, .running, .hiking]
    private let locationTypes: [LocationType] = [.outdoor, .indoor]

    // MARK: - IBOutlets

    @IBOutlet private var activityTypePicker: UIPickerView!
    @IBOutlet private var locationTypePicker: UIPickerView!

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case activityTypePicker:
            return activityTypes.count
        case locationTypePicker:
            return locationTypes.count
        default:
            return 0
        }
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case activityTypePicker:
            return activityTypes[row].displayString()
        case locationTypePicker:
            return locationTypes[row].displayString()
        default:
            return nil
        }
    }

    // MARK: - Segues

    @IBAction private func unwindToConfiguration(segue: UIStoryboardSegue) {
        // Nothing to do
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentWorkoutSegue" {
            prepareForPresentWorkoutSegue(segue)
        }
    }

    private func prepareForPresentWorkoutSegue(_ segue: UIStoryboardSegue) {
        let selectedActivityType = activityTypes[activityTypePicker.selectedRow(inComponent: 0)]
        let selectedLocationType = locationTypes[locationTypePicker.selectedRow(inComponent: 0)]

        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = selectedActivityType.type()
        workoutConfiguration.locationType = selectedLocationType.type()

        let workoutViewController = segue.destination as? WorkoutViewController
        workoutViewController!.configuration = workoutConfiguration
    }
}
