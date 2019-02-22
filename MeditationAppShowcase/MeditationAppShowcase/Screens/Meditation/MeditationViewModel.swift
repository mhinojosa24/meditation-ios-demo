protocol MeditationViewModeling: class {
    var latestSongViewModels: (([SongViewModeling]) -> Void)? { get set }
    func didSelect(isSelected: Bool, index: Int)
    func viewDidAppear()
    func viewWillDisappear()
    func backAction()
    var closeMeditation: (() -> Void)? { get set }
}

class MeditationViewModel: MeditationViewModeling {

    init(actionOperator: ActionOperating,
         tabBarOperator: TabBarOperating,
         songViewModels: [SongViewModeling],
         modeOperator: SongModeOperating = SongModeOperator()) {
        self.actionOperator = actionOperator
        self.tabBarOperator = tabBarOperator
        self.songViewModels = songViewModels
        self.modeOperator = modeOperator
    }

    // MARK: - MeditationViewModeling

    var latestSongViewModels: (([SongViewModeling]) -> Void)?

    func didSelect(isSelected: Bool, index: Int) {
        let oldMode = songViewModels[index].songMode
        let newMode = modeOperator.toSelected(isSelected, mode: oldMode)
        songViewModels[index].songMode = newMode
    }

    func viewDidAppear() {
        latestSongViewModels?(songViewModels)
        disposable = actionOperator.actionHandler.addHandler(
            target: self,
            handler: MeditationViewModel.handleAction)
        tabBarOperator.isBarVisible = true
    }

    func viewWillDisappear() {
        disposable?.dispose()
    }

    func backAction() {
        closeMeditation?()
    }

    // MARK: - MeditationViewOperating

    var closeMeditation: (() -> Void)?

    // MARK: - Privates

    private let actionOperator: ActionOperating
    private let tabBarOperator: TabBarOperating
    private let songViewModels: [SongViewModeling]
    private let modeOperator: SongModeOperating
    private var disposable: Disposable?

    private func handleAction(action: ActionViewController.Action) {
        actionOperator.set(mode: .player)
    }

}
