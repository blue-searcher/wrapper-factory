# wrapped-factory

UI: [wrapper-factory.vercel.app](https://wrapper-factory.vercel.app)

Factory contract to deploy wrapped tokens.

#### Factory
`WrapperFactory.deploy()` function deploys an ERC20 which can be exchanged at a fixed ratio to the supplied token. The wrapper token balances are handled as shares of deposited token, so it can handle both standard and rebasing ERC20 tokens. The ratio will obviously change over time for rebasing tokens.

Can be used to create [WOOFY](https://etherscan.io/address/0xd0660cd418a64a1d44e9214ad8e459324d8157f1#code)-style and [wstETH](https://etherscan.io/address/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0#code)-style tokens.

The *ratio* parameter should be set to `10**18` in order to have a 1:1 exchange rate.

#### Wrapper tokens

Each wrapper token deployed by the factory contract share the same interface.

State changing functions:
- `wrap(uint256 _tokenAmount, address _receiver)`
- `unwrap(uint256 _wrapperAmount, address _receiver)`

View functions:
- `getWrapAmountOut(uint256 _tokenAmount)`
- `getUnwrapAmountOut(uint256 _wrapperAmount)`


Inspired by [Generalized Wrapper-token Factory](https://mirror.xyz/kyoro.eth/4wHrYiOr7QlVOFdK4jMSEMz6yOdWD53QFazEn_acfFQ) post.

Deployed on [Goerli Testnet](https://goerli.etherscan.io/address/0xE6eB6B9AB5DeB33e77A63673d6a2c2C06539373e).
