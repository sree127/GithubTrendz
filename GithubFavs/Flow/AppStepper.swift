//
//  AppStepper.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import RxFlow
import RxCocoa

final class AppStepper: Stepper {
  let steps = PublishRelay<Step>()
  let initialStep: Step = AppFlowStep.initial
}
