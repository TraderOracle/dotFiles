# Get the current price of Ethereum
PRICE=$(curl -s -X GET "https://api.coinbase.com/v2/prices/ETH-USD/spot" | jq -r '.data.amount' | cut -d. -f1)

# Get the current gas price, relace with your API KEY
GAS_PRICE=$(curl -s -X GET "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=YOURAPIKEYHERE" | jq -r '.result.SafeGasPrice' | awk '{print int($1+0.5)}')

# Add it to sketchybar
sketchybar --set $NAME label="\$$PRICE ($GAS_PRICE gwei)" icon=
