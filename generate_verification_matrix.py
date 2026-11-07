import docx
from docx.shared import Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

def create_report():
    doc = docx.Document()
    
    # Title
    title = doc.add_heading('raay Audit Verification Matrix', 0)
    title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    doc.add_paragraph('Focused Read-Only Verification of Unresolved Issues\n').alignment = WD_ALIGN_PARAGRAPH.CENTER
    
    table = doc.add_table(rows=1, cols=7)
    table.style = 'Table Grid'
    hdr = table.rows[0].cells
    hdr[0].text = 'Finding ID'
    hdr[1].text = 'Source File / Lines'
    hdr[2].text = 'Test Performed / Inspection'
    hdr[3].text = 'Actual Result'
    hdr[4].text = 'Status'
    hdr[5].text = 'Severity'
    hdr[6].text = 'Recommended Correction'
    
    findings = [
        ("M6-1", "lib/features/results/domain/event_result.dart\nfunctions/src/results/tally.ts", "npm test src/__tests__/results/tally.test.ts", "Tally correctly passes totalVotes. Flutter model parses 'totalVotes' and maps 'tallies' array cleanly.", "Verified", "None", "None. Contract is reconciled."),
        ("SEC-1", "functions/src/voting/castVote.ts (Lines 110-150)\nfirestore.rules (votes collection)", "Inspection of transaction logic", "Transaction writes completely isolated identifiable 'participation' document and anonymous 'votes' document.", "Verified", "None", "None. Anonymity is preserved."),
        ("SEC-2", "firestore.rules\nlib/features/voting/.../receipt_screen.dart", "Route & UI analysis", "voteReceipts collection exists and receipt is issued. However, there is no public unauthenticated verifier UI to check the SHA-256 hash against the ledger.", "Unverified", "High", "Build a public independent Receipt Verification portal (New Functionality)."),
        ("SEC-3", "lib/features/voting/presentation/cast_vote_screen.dart (Lines 60-70)", "Inspection of DateTime.now() usage", "Frontend relies on local clock to disable submit button. However, backend successfully rejects late submissions due to FieldValue.serverTimestamp() checks.", "Verified", "Low", "Backend is secure, but UI should sync with server time to prevent frustrated users."),
        ("SUP-1", "lib/features/support/presentation/help_support_screen.dart", "Source code inspection", "Screen implements a functional feedback form writing to the 'userReports' collection. It is NOT just a static FAQ.", "Verified", "None", "None. Support ticket collection logic exists, though a dedicated admin dashboard for them is missing."),
        ("RTE-1", "lib/core/router/app_router.dart", "Route mapping comparison", "All 31 screens from the reference map cleanly to the GoRouter configuration (e.g., /orgs, /admin/events, /elections/:eventId/results).", "Verified", "None", "None."),
        ("RTE-2", "lib/core/router/app_router.dart", "Route mapping comparison", "No route exists for the public Receipt Verifier or Election Templates.", "Unverified", "Medium", "Add routes during Phase 2 (Enterprise Expansion)."),
        ("UX-1", "lib/core/presentation/app_navigation_shell.dart", "Static layout tree analysis", "Uses Theme.of(context).brightness successfully. Navigation shell uses Row/Column combinations accurately switching between Desktop Sidebar and Mobile Bottom Nav.", "Verified", "None", "None."),
        ("UX-2", "lib/features/organizations/presentation/organization_dashboard_screen.dart", "Static layout tree analysis", "Still utilizing old generic Material 3 ListViews rather than the new Premium Grid layout.", "Unverified", "High", "Must refactor Dashboard screens before release using raayCard/raayMetricCard."),
        ("EDG-1", "lib/features/organizations/presentation/providers/organization_providers.dart", "Inspection of memberInvitationsProvider", "Uses Stream.periodic(Duration(seconds: 45)) instead of Firestore real-time .snapshots().", "Unverified", "Low", "Refactor to use .snapshots() for instant delivery and lower bandwidth."),
        ("EDG-2", "lib/features/organizations/presentation/providers/organization_providers.dart", "Inspection of activeOrganizationContextProvider", "If membership is revoked mid-session, state resolves to null (empty context). It does not gracefully redirect.", "Unverified", "Low", "Implement auto-redirect to '/home' or alternate organization if context drops.")
    ]
    
    for f_id, src, test, result, status, sev, rec in findings:
        row = table.add_row().cells
        row[0].text = f_id
        row[1].text = src
        row[2].text = test
        row[3].text = result
        row[4].text = status
        row[5].text = sev
        row[6].text = rec

    doc.save('artifacts/raay_Verification_Matrix.docx')
    print("Matrix generated.")

if __name__ == "__main__":
    create_report()
