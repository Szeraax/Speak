# Input bindings are passed in via param block.
param($QueueItem, $TriggerMetadata)

$item_raw = $QueueItem | ConvertTo-Json -Depth 10 -Compress
$item = $item_raw | ConvertFrom-Json

# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $QueueItem"
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"

$names = @(
    'Luke Skywalker', 'Han Solo', 'General Leia', 'Princess Leia', 'Indiana Jones', 'Neo',
    'Katniss Everdeen', 'James Bond', 'Harry Potter', 'John McClane', 'Rocky Balboa', 'Forrest Gump',
    'Tony Stark', 'Sarah Connor', 'Darth Vader', 'The Joker', 'Voldemort', 'Princess Leia Organa',
    'Obi-Wan Kenobi', 'Yoda', 'R2-D2', 'C-3PO', 'Chewbacca', 'Emperor Palpatine',
    'Boba Fett', 'Lando Calrissian', 'Jabba the Hutt', 'Padmé Amidala', 'Mace Windu', 'Qui-Gon Jinn',
    'Anakin Skywalker', 'Jango Fett', 'Count Dooku', 'General Grievous', 'Ahsoka Tano', 'Finn',
    'Rey', 'Poe Dameron', 'Kylo Ren', 'BB-8', 'Captain Phasma', 'Jyn Erso',
    'Cassian Andor', 'Director Krennic', 'Sauron', 'James T. Kirk', 'Spock', 'Leonard McCoy',
    'Jean-Luc Picard', 'William Riker', 'Deanna Troi', 'Worf', 'Geordi La Forge', 'Beverly Crusher',
    'Wesley Crusher', 'Benjamin Sisko', 'Kira Nerys', 'Jadzia Dax', 'Julian Bashir', 'Odo',
    'Quark', 'Agent Smith', 'Hans Gruber', 'Ursula', 'Maleficent', 'Joker',
    'Aragorn', 'Gandalf', 'Frodo Baggins', 'Samwise Gamgee', 'Bilbo Baggins', 'Gollum',
    'Legolas', 'Magneto', 'Wolverine', 'Professor X', 'Mystique', 'Marty McFly',
    'Doc Brown', 'Ferris Bueller', 'Sherlock Holmes', 'Dr. John Watson', 'Danny Ocean', 'The Terminator',
    'RoboCop', 'Maximus', 'Hal 9000', 'The Wicked Witch of the West', 'Godzilla', 'Marko Ramius',
    'Kong', 'Khan', 'Captain Ahab', 'Mr. Spock', 'Jason Bourne', 'Jack Sparrow',
    'Willy Wonka', 'The Mad Hatter', 'Captain Jack Sparrow', 'Morpheus', 'Trinity', 'Zorro',
    'Rambo', 'Tarzan', 'Dracula', 'The Wolf Man', 'The Mummy', 'The Phantom of the Opera',
    'Bane', 'Two-Face', 'Catwoman', 'The Riddler', 'The Scarecrow', 'Bruce Wayne',
    'Batman', 'Clark Kent', 'Superman', 'Lois Lane', 'Spider-Man', 'Peter Parker',
    'Gwen Stacy', 'Mary Jane Watson', 'Doctor Octopus', 'Green Goblin', 'Harry Osborn', 'Eddie Brock',
    'Steve Rogers', 'Captain America', 'Iron Man', 'Black Widow', 'Hawkeye', 'Bruce Banner',
    'Dr. Strange', 'Charles Xavier', 'Scott Summers', 'Jean Grey', 'Nightcrawler', 'Kurt Wagner',
    'The Tooth Fairy', 'Prince Caspian', 'Hiccup', 'Toothless', 'Frozone', 'Edna Mode',
    'Mr. Incredible', 'Elastigirl', 'Ron Weasley', 'Hermione Granger', 'Albus Dumbledore', 'Severus Snape',
    'Lord Voldemort', 'Neville Longbottom', 'Draco Malfoy', 'Ginny Weasley', 'Luna Lovegood', 'Fred Weasley',
    'George Weasley', 'Sirius Black', 'Remus Lupin', 'Bellatrix Lestrange', 'Rubeus Hagrid', 'Minerva McGonagall',
    'Molly Weasley', 'Dolores Umbridge', 'Gimli', 'Boromir', 'Merry Brandybuck', 'Pippin Took',
    'Galadriel', 'Elrond', 'Arwen', 'Treebeard', 'Faramir', 'Eowyn',
    'Theoden', 'Saruman', 'Thor', 'Doctor Strange', 'Scarlet Witch', 'Black Panther',
    'Ant-Man', 'Captain Marvel', 'Winter Soldier', 'Nick Fury', 'Maria Hill', 'Phil Coulson',
    'Loki', 'Thanos', 'Ultron', 'Red Skull', 'The Mandarin', 'Hela',
    'Valkyrie', 'Okoye', 'Gamora', 'Groot', 'Mickey Mouse', 'Minnie Mouse',
    'Donald Duck', 'Goofy', 'Pluto', 'Cinderella', 'Snow White', 'Belle',
    'Ariel', 'Aladdin', 'Simba', 'Woody', 'Buzz Lightyear', 'Elsa',
    'Moana', 'Homer Simpson', 'Marge Simpson', 'Bart Simpson', 'Lisa Simpson', 'Maggie Simpson',
    'Ned Flanders', 'Krusty the Clown', 'Mr. Burns', 'Sideshow Bob', 'Wonder Woman', 'Harley Quinn',
    'Aquaman', 'The Flash', 'Green Lantern', 'Elizabeth Swann', 'Will Turner', 'Captain Barbossa',
    'Davy Jones', 'Hector Barbossa', 'Blackbeard', 'Angelica', 'Commodore Norrington', 'Seven of Nine',
    'Captain Janeway', 'Alan Grant', 'Ian Malcolm', 'John Hammond', 'Dennis Nedry', 'Beaker',
    'Statler and Waldorf', 'Pepe the King Prawn', 'Bunsen Honeydew', 'Rizzo the Rat', 'Camilla the Chicken', 'Uncle Deadly',
    'Kermit the Frog', 'Miss Piggy', 'Fozzie Bear', 'Gonzo the Great', 'Rowlf the Dog', 'Dr. Teeth',
    'Sam Eagle', 'Swedish Chef', 'Jack Ryan', 'King Kong'
)

function Send-Response {
    param(
        $Message,
        $Method = 'Patch',
        $Response = (@{
                type    = 4
                content = $message
            } | ConvertTo-Json -EscapeHandling EscapeNonAscii)
    )
    if ($ENV:ENV_DEBUG -eq 1) { "Response: $response" | Write-Host }
    $invokeRestMethod_splat = @{
        Uri               = "https://discord.com/api/v8/webhooks/{0}/{1}/messages/@original" -f $item.application_id, $item.token
        Method            = $method
        ContentType       = "application/json"
        Body              = $response
        MaximumRetryCount = 5
        RetryIntervalSec  = 1
    }
    $invokeRestMethod_splat.Uri | Write-Host
    try { Invoke-RestMethod @invokeRestMethod_splat | Out-Null }
    catch {
        "failed" | Write-Host
        $invokeRestMethod_splat | ConvertTo-Json -Depth 3 -Compress
        $_
    }
}

function Set-DiscordRoleMembership {
    param(
        [Alias('InputObject')]
        [Parameter(ValueFromPipeline)]
        [string[]]$RoleName,

        # PUT method adds a user to a role. DELETE removes.
        # If PUT, will not error if user is already part of the role
        # If DELETE, will not error if user is already not part of the role
        [ValidateSet("PUT", "DELETE")]
        $Method
    )
    begin {
        $token = [Environment]::GetEnvironmentVariable("APP_DISCORD_BOT_TOKEN_$($item.application_id)")
        $headers = @{
            Authorization = "Bot $token"
        }
        $irm_splat = @{
            MaximumRetryCount = 1
            RetryIntervalSec  = 1
            ContentType       = 'application/json'
            UserAgent         = 'DiscordBot (https://dcrich.net,0.0.1)'
            Headers           = $headers
            ErrorAction       = 'Stop'
        }

        $irm_splat.Uri = "https://discord.com/api/guilds/$($item.Guild_ID)/roles"
        $roles = Invoke-RestMethod @irm_splat
    }
    process {
        $role = $roles | Where-Object { $_.name -eq $RoleName } | Select-Object -First 1
        if (-not [string]::IsNullOrWhiteSpace($role.id)) {
            $irm_splat.Uri = "https://discord.com/api/guilds/$($item.Guild_ID)/members/$($item.member.user.id)/roles/$($role.id)"
            try {
                Invoke-RestMethod @irm_splat -Method Method
            }
            catch {}
        }
    }
}




if (-not [string]::IsNullOrWhiteSpace($ENV:APP_SERVER_ONLY) -and $item.guild_id -ne $ENV:APP_SERVER_ONLY) {
    Send-Response -Message "Sorry, the bot is currently disabled. Please try again later."
    return
}

$commandName = @(
    $item.data.name
    $item.data.options | Where-Object type -In 1, 2 | Select-Object -First 1 -expand name
    $item.data.options.options | Where-Object type -In 1, 2 | Select-Object -First 1 -expand name
) -join "_"
Write-Host $commandName

$token = [Environment]::GetEnvironmentVariable("APP_DISCORD_BOT_TOKEN_$($item.application_id)")
$headers = @{
    Authorization = "Bot $token"
}
$irm_splat = @{
    MaximumRetryCount = 4
    RetryIntervalSec  = 2
    ContentType       = 'application/json'
    UserAgent         = 'DiscordBot (https://dcrich.net,0.0.1)'
    Headers           = $headers
    ErrorAction       = 'Stop'
}

try {
    $irm_splat.Uri = "https://discord.com/api/guilds/$($item.Guild_ID)/members/$($item.member.user.id)"
    $member = Invoke-RestMethod @irm_splat
    $member | ConvertTo-Json -Depth 10 -Compress | Write-Host
    "Got member" | Write-Host



    $message = $item.data.options |
    Where-Object name -EQ 'message' |
    Select-Object -First 1 |
    Select-Object -expand value

    $message | Write-Host

    $role = $item.data.options |
    Where-Object name -EQ 'role' |
    Select-Object -First 1 |
    Select-Object -expand value

    $hashOutput = Get-FileHash -Algorithm MD5 -InputStream ([System.IO.MemoryStream]::New([System.Text.Encoding]::UTF8.GetBytes(
        (Get-Date).ToShortDateString() + $($item.member.user.id)
            )))
    $color = ($hashOutput.Hash.Tolower().ToCharArray() | Select-Object -First 6) -join ''
    $namePicker = ($hashOutput.Hash.Tolower().ToCharArray() | Select-Object -First 2) -join ''
    $signature = "-{0}" -f $names[[Convert]::ToInt64($namePicker, 16)]

    if ($role ) {
        if ($role -in $member.roles -or $commandName -eq 'Speak_Any_Role') {
            $signature += " (<@&$role>)"
        }
        else {
            Send-Response "You are not a member of the <@&$role> role."
            return
        }
    }

    $body = @{
        content = $message
        embeds  = @(
            @{
                description = $signature
                # url         = "https://trustcircle.azurewebsites.net/api/circles?guild=$($body.guild_id)&skip=0&take=10"
                # description = $message
                color       = [Convert]::ToInt64($color, 16)
            }
        )
        # allowed_mentions = {
        #     users = @("123", "124")
        #     roles = @()
        # }
    }

    # We only need to check role permissions if you are mentioning another user/role/everyone
    if ($message -match '@') {
        try {
            $irm_splat.Uri = "https://discord.com/api/guilds/$($item.Guild_ID)/roles"
            $roles = Invoke-RestMethod @irm_splat
            $roles[1] | ConvertTo-Json -Depth 10 -Compress | Write-Host
            $role = $roles | Where-Object { $_.name -eq $RoleName } | Select-Object -First 1
            # if $role.permissions -shl 17 -eq $true (#MENTION_EVERYONE -shl 17), add 'Everyone' to Parse

            $body.allowed_mentions = @{
                parse = @()
            }
        }
        catch {
            $body.allowed_mentions = @{
                parse = @()
            }

        }

    }


    $irm_splat.Uri = "https://discord.com/api/channels/$($item.channel_id)/messages"
    try {
        $messaage = Invoke-RestMethod @irm_splat -Method post -Body ($body | ConvertTo-Json -EscapeHandling EscapeNonAscii)
        Send-Response -message "Done!" -method DELETE
    }
    catch {
        if (($_ | ConvertFrom-Json).message -match "Missing Access") {
            Send-Response -message "'Missing Access' error. Does the speak bot have permissions to see and send messages to this channel?"
        }
        else {
            Send-Response -Message "Failed to upload message. Try again?"
        }
    }
}
catch {
    $_
    Send-Response -message 'Failed for some reason. Try again?'
}

#Region modlog
$irm_splat.Uri = "https://discord.com/api/guilds/$($item.Guild_ID)/channels"
$channels = Invoke-RestMethod @irm_splat
"Got channels" | Write-Host
if ($modlog = $channels | Where-Object name -EQ "modlog") {}
elseif ($modlog = $channels | Where-Object name -EQ "moderation") {}
elseif ($modlog = $channels | Where-Object name -EQ "moderation-log") {}

if ($modlog) {
    $irm_splat.Uri = "https://discord.com/api/channels/$($modlog.id)/messages"
    $body = @{
        embeds = @(
            @{
                description = "New message sent via ${commandname}: {0}`nFrom: <@{1}> {2}" -f @(
                    "https://discord.com/channels/$($item.Guild_ID)/$($item.channel_id)/$($messaage.id)"
                    $item.member.user.id
                    $signature
                )
                color       = [Convert]::ToInt64($color, 16)
            }
        )
    } | ConvertTo-Json -EscapeHandling EscapeNonAscii
    try {
        Invoke-RestMethod @irm_splat -Method post -Body $body | Out-Null
    }
    catch {
        if (($_ | ConvertFrom-Json).message -match "Missing Access") {
            "'Missing Access' error. Does the speak bot have permissions to see and send messages to this channel?" | Write-Host
        }
        else {
            "Failed to message modlog" | Write-Warning
        }
    }
}
else {
    "No modlog found" | Write-Host
}
#EndRegion modlog


# TODO:
# Add send any command
# submit to modlog and alterante modlog channels
