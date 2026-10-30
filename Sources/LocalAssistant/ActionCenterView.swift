import SwiftUI
struct ActionCenterView: View {
    @ObservedObject var store: AssistantStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 14) { PebbleAvatar(size: 60); VStack(alignment: .leading, spacing: 4) { Text("A little help, with your say.").font(.system(size: 25, weight: .semibold, design: .rounded)); Text("Plan locally. Review exactly. Approve one action.").foregroundStyle(.secondary) } }
                Text("Pebble can open Safari searches, open explicit HTTPS links, and read a basic Mac summary. It cannot read your screen, browse results, run terminal commands, control other apps, or send messages.").font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 10) {
                    Text("ASK FOR AN ACTION").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    TextEditor(text: $store.actionDraft).scrollContentBackground(.hidden).frame(height: 90).padding(8).background(.quaternary, in: RoundedRectangle(cornerRadius: 12)).accessibilityLabel("Action request").disabled(store.busy)
                    HStack {
                        if store.busy { ProgressView().controlSize(.small); if store.executingAction { Text("Performing approved action…") } else { Button("Cancel") { store.cancel() } } }
                        else { Button("Propose action") { store.planAction() }.buttonStyle(.borderedProminent).foregroundStyle(Color.onCobalt).disabled(store.actionDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) }
                        Text("Planning uses the selected local engine.").font(.caption).foregroundStyle(.secondary)
                    }
                }
                Divider()
                Text("OR CHOOSE A REVIEWABLE ACTION").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                HStack {
                    Button("Search in Safari") { store.propose(kind: .searchSafari, value: store.actionDraft) }.disabled(store.actionDraft.isEmpty || store.busy)
                    Button("Open HTTPS link") { store.propose(kind: .openSafariURL, value: store.actionDraft) }.disabled(store.actionDraft.isEmpty || store.busy)
                    Button("Review this Mac") { store.propose(kind: .reviewMac) }.disabled(store.busy)
                }
                Text(store.actionStatus).font(.callout).textSelection(.enabled).fixedSize(horizontal: false, vertical: true)
                if !store.actionResult.isEmpty { Divider(); Text("LAST COMPLETED ACTION · " + store.lastActionTitle).font(.caption.weight(.semibold)).foregroundStyle(.secondary); Text(store.actionResult).textSelection(.enabled).frame(maxWidth: .infinity, alignment: .leading) }
            }.padding(28).frame(maxWidth: 1000, alignment: .leading).frame(maxWidth: .infinity, alignment: .leading)
        }.background(.background)
        .sheet(item: $store.pendingAction, onDismiss: { if store.pendingAction != nil { store.cancelApproval() } }) { proposal in
            VStack(alignment: .leading, spacing: 18) {
                Label("Approve one action", systemImage: "hand.raised").font(.title2.weight(.semibold))
                Text(proposal.title).font(.headline)
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(proposal.disclosure).fixedSize(horizontal: false, vertical: true)
                        if !proposal.value.isEmpty { Text(proposal.value).font(.body.monospaced()).textSelection(.enabled).padding(12).frame(maxWidth: .infinity, alignment: .leading).background(.quaternary, in: RoundedRectangle(cornerRadius: 10)) }
                        if let url = proposal.destination { Text("Exact destination: " + url.absoluteString).font(.caption.monospaced()).textSelection(.enabled).fixedSize(horizontal: false, vertical: true) }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxHeight: 320)
                Text("Approval applies once to this exact action and expires after five minutes.").font(.caption).foregroundStyle(.secondary)
                HStack { Button("Cancel") { store.cancelApproval() }.keyboardShortcut(.cancelAction); Spacer(); Button("Approve & run") { store.approveAction(id: proposal.id) }.buttonStyle(.borderedProminent).foregroundStyle(Color.onCobalt) }
            }.padding(28).frame(width: 530)
        }
    }
}
