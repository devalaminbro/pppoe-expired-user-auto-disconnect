# ============================================================
# MikroTik PPPoE Auto-Disconnect & Suspend Script
# Author: Sheikh Alamin Santo
# Description: Disables users whose expiry date has passed
# ============================================================

# --- 1. Get System Date ---
:local currentDate [/system clock get date];
:local currentMonth [:pick $currentDate 0 3];
:local currentDay [:pick $currentDate 4 6];
:local currentYear [:pick $currentDate 7 11];

# Convert Month Name to Number
:local months ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
:local monthNum 0;
:foreach m in=$months do={
    :if ($m = $currentMonth) do={ :set monthNum ($months->$m); }
}

# --- 2. Iterate Through All PPP Secrets ---
/ppp secret
:foreach i in=[find where disabled=no] do={
    
    # Get User Comment (Expected Format: "Name | EXP: YYYY-MM-DD")
    :local comment [get $i comment];
    :local uName [get $i name];
    
    # Check if comment contains "EXP:"
    :if ([:find $comment "EXP:"] >= 0) do={
        
        # Extract Date from Comment
        :local expPos [:find $comment "EXP:"];
        :local expDateStr [:pick $comment ($expPos + 5) ($expPos + 15)];
        
        # Parse Expiry Date
        :local expYear [:pick $expDateStr 0 4];
        :local expMonth [:pick $expDateStr 5 7];
        :local expDay [:pick $expDateStr 8 10];
        
        # --- 3. Compare Dates & Take Action ---
        # Logic: If Current Year > Exp Year OR (Same Year AND Current Month > Exp Month)...
        
        :local isExpired false;
        
        :if ($currentYear > $expYear) do={ :set isExpired true; }
        :if ($currentYear = $expYear) do={
             :if ($monthNum > $expMonth) do={ :set isExpired true; }
             :if ($monthNum = $expMonth) do={
                 :if ($currentDay > $expDay) do={ :set isExpired true; }
             }
        }
        
        # If Expired, Disable User & Kill Active Session
        :if ($isExpired = true) do={
            /ppp secret disable $i;
            
            # Remove Active Connection
            :local activeID [/ppp active find where name=$uName];
            :if ($activeID != "") do={
                /ppp active remove $activeID;
            }
            
            :log warning "SUSPENDED: User $uName expired on $expDateStr. Account Disabled.";
        }
    }
}

/log info "Billing Check Complete. Expired users suspended.";
