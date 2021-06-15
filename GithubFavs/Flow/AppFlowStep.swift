//
//  AppFlowStep.swift
//  GithubTrendz
//
//  Created by Sreejith Njamelil on 15.06.21.
//

import RxFlow

enum AppFlowStep: Step {
  case initial
  case repoDetails(ownerName: String, repoName: String)
}
