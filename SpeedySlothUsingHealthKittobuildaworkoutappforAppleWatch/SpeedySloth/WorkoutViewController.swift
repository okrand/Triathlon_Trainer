/*
See LICENSE.txt for this sample’s licensing information.

Abstract:
View controller for the active workout screen.
*/

import Foundation

import UIKit
import HealthKit
import WatchConnectivity

class WorkoutViewController: UIViewController, WCSessionDelegate {

    // MARK: - Properties

    var configuration: HKWorkoutConfiguration?

    private let healthStore = HKHealthStore()
    private var wcSessionActivationCompletion: ((WCSession) -> Void)?
    private var watchConnectivitySession: WCSession?
    private var stateDate: Date?

    @IBOutlet private var workoutSessionState: UILabel!

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startWatchApp()
    }

    // MARK: - Convenience

    private func startWatchApp() {
        guard let workoutConfiguration = configuration else { return }

        getActiveWCSession { wcSession in
            if wcSession.activationState == .activated && wcSession.isWatchAppInstalled {
                self.healthStore.startWatchApp(with: workoutConfiguration) { (success, error) in
                    if !success {
                        print("starting watch app failed with error: \(String(describing: error))")
                    }
                }
            }
        }
    }

    private func getActiveWCSession(completion: @escaping (WCSession) -> Void) {
        guard WCSession.isSupported() else {
            // ... Alert the user that their iOS device does not support watch connectivity
            fatalError("watch connectivity session not supported")
        }

        let wcSession = WCSession.default
        wcSession.delegate = self

        switch wcSession.activationState {
        case .activated:
            completion(wcSession)
        case .inactive, .notActivated:
            wcSession.activate()
            wcSessionActivationCompletion = completion
        }
    }

    private func updateSessionState(_ state: String) {
        if state == "ended" {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        } else {
            workoutSessionState.text = state
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if activationState == .activated, let activationCompletion = wcSessionActivationCompletion {
            activationCompletion(session)
            wcSessionActivationCompletion = nil
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let state = message["State"] as? String {
            DispatchQueue.main.async {
                self.updateSessionState(state)
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }
}
