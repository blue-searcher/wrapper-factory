# wrapped-factory

Factory contract to deploy wrapped tokens.

Usage: 
- `WrapperFactory.deployFixedRatioWrapper()` deploys a wrappedERC20 which can be exchanged at a fixed ratio to the supplied token. Can be used to create [WOOFY](https://etherscan.io/address/0xd0660cd418a64a1d44e9214ad8e459324d8157f1#code)-style tokens.

The *ratio* parameter should be set to `10**18` in order to have a 1:1 exchange rate.

Ideally, this would become a factory to deploy various types of wrapped tokens.

Inspired by [Generalized Wrapper-token Factory](https://mirror.xyz/kyoro.eth/4wHrYiOr7QlVOFdK4jMSEMz6yOdWD53QFazEn_acfFQ) post.